#!/usr/bin/env bash

app_name=$1


echo "Update application $app_name on ArgoCD .."
# deploy apps
kubectl apply -f $PWD/configurations/appsets/$app_name/$app_name.yml