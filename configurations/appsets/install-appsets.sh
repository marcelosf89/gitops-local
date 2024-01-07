#!/usr/bin/env bash

app_name=$1
repo_appsets=$2
pat_token=$3

local_port=9001

# Get the password
ARGOCD_SERVER_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

argocd login --insecure --grpc-web --username admin --password $ARGOCD_SERVER_PASSWORD localhost:$local_port

# Add gitops-local repo
argocd repo --insecure --grpc-web add $repo_appsets --username git --password $pat_token --insecure-skip-server-verification

echo "Install application $app_name on ArgoCD .."
# deploy apps
kubectl apply -f $PWD/configurations/appsets/$app_name/$app_name.yml