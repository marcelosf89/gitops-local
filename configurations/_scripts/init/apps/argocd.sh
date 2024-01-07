#!/usr/bin/env bash

# Deploy argocd

echo "Deploying ArgoCD..."

kubectl create ns argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.9.3/manifests/install.yaml 
kubectl apply -f $PWD/configurations/_scripts/init/apps/argocd-ingress.yaml

# Restart argocd server

echo "Restarting ArgoCD Server..."
kubectl rollout restart deploy  -n argocd argocd-server


