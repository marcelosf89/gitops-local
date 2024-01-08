#!/usr/bin/env bash

# Deploy argocd
namespace=argocd
server_name=argocd-server

echo "Deploying ArgoCD..."

kubectl create namespace $namespace &> /dev/null 
echo "Install ArgoCD ..."
kubectl apply -n $namespace -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.9.3/manifests/install.yaml 

echo "Override ArgoCD configurations ..."
kubectl apply -f $PWD/configurations/scripts/init/apps/argocd-override-settings.yml

# Restart argocd server

echo "Restarting ArgoCD Server..."
kubectl rollout restart deploy  -n $namespace $server_name


echo "Waiting for $server_name to be ready..."
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/name=$server_name -n argocd --timeout=300s

# Port forward argocd-server to avoid create a tunnel on minikube
local_port=9001
port_forwarding_pid=$(pgrep -f "kubectl port-forward svc/$server_name -n $namespace $local_port:8080")

if [ -n "$port_forwarding_pid" ]; then
    echo "Port forwarding for $server_name is already running."
else
    echo "Port forwarding $server_name to localhost:$local_port"
    kubectl port-forward svc/$server_name -n $namespace $local_port:8080 &
fi