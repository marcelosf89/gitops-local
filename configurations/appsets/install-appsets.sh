#!/usr/bin/env bash

app_name=$1
repo_appsets=$2
pat_token=$3
app_foward_port=$4

local_port=9001

# Get the password
ARGOCD_SERVER_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

argocd login --insecure --grpc-web --username admin --password $ARGOCD_SERVER_PASSWORD localhost:$local_port

# Add gitops-local repo
repo_exists=$(argocd repo list | grep $repo_appsets)

if [ -n "$repo_exists" ]; then
    echo "Repository $repo_appsets already exists in ArgoCD."
else
    echo "Adding repository $repo_appsets to ArgoCD."
    argocd repo --insecure --grpc-web add $repo_appsets --username git --password $pat_token --insecure-skip-server-verification
fi


echo "Install/Update application $app_name on ArgoCD .."

# Deploy apps
kubectl apply -f $PWD/configurations/appsets/$app_name/$app_name.yml

port=$(kubectl get svc -n $app_name $app_name-service -o jsonpath='{.spec.ports[].port}')

port_forwarding_pid=$(pgrep -f "kubectl port-forward svc/$app_name-service -n $app_name $app_foward_port:$port")

if [ -n "$port_forwarding_pid" ]; then
    echo "Port forwarding for $app_name is already running."
else
    echo "Port forwarding $app_name-service to localhost:$port >> localhost:$app_foward_port"
    kubectl port-forward svc/$app_name-service -n $app_name $app_foward_port:$port &
fi

