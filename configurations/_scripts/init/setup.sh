#!/usr/bin/env bash

# Check if minikube is installed

MINIKUBE_LOCAL=$(which minikube)

if [ -z "$MINIKUBE_LOCAL" ]; then
    echo "Minikube is not installed, please run 'make minikube-install'"
    exit 1
fi

# Check if minikube is running if not start it
MINIKUBE_STATUS=$(minikube status | grep "host: Running")

if [ -z "$MINIKUBE_STATUS" ]; then
    minikube start
fi

# Enable addons
minikube addons enable ingress

#1. Deploy argocd on minikube
$PWD/configurations/_scripts/init/apps/argocd.sh
