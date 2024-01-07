#!/usr/bin/env bash
path=$PWD/configurations/third_parties/observability

mkdir -p $path/.ignore

kubectl create namespace observability

helm template $path > $path/.ignore/dashboards.yaml
kubectl apply -f $path/.ignore/dashboards.yaml

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade --namespace observability -f $path/values.yaml metrics prometheus-community/kube-prometheus-stack --version 55.5.0