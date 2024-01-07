#!/usr/bin/env bash

# Deploy argocd

echo "Deploying ArgoCD..."

kubectl create ns argocd
echo "Install ArgoCD ..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.9.3/manifests/install.yaml 

echo "Override ArgoCD configurations ..."
kubectl apply -f $PWD/configurations/_scripts/init/apps/argocd-override-settings.yml

# Restart argocd server

echo "Restarting ArgoCD Server..."
kubectl rollout restart deploy  -n argocd argocd-server


echo "Waiting for argocd-server to be ready..."
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

# Port forward argocd-server to avoid create a tunnel on minikube

local_port=9001
echo "Port forwarding argocd-server to localhost:$local_port"
kubectl port-forward svc/argocd-server -n argocd $local_port:8080 &

# port-forward pid
pid=$!
