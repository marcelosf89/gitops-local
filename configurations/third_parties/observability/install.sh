#!/usr/bin/env bash
path=$PWD/configurations/third_parties/observability

mkdir -p $path/.ignore
namespace=observability
name=metrics

kubectl create namespace $namespace &> /dev/null

helm template $path > $path/.ignore/dashboards.yaml
kubectl apply -f $path/.ignore/dashboards.yaml

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update


if helm status $name -n $namespace &> /dev/null; then
    helm_action="install"
else
    helm_action="upgrade"
fi

echo "$helm_action $name on namespace $namespace"
helm $helm_action $name -n $namespace -f $path/values.yaml prometheus-community/kube-prometheus-stack --version 55.5.0


prometheus_local_port=9090
port_forwarding_pid=$(pgrep -f "kubectl port-forward svc/prometheus-operated -n $namespace $prometheus_local_port:9090")

if [ -n "$port_forwarding_pid" ]; then
    echo "Port forwarding for Prometheus is already running."
else
    echo "Port forwarding prometheus-operated to localhost:$prometheus_local_port"
    kubectl port-forward svc/prometheus-operated -n $namespace $prometheus_local_port:9090 &
fi



grafana_local_port=9002
port_forwarding_pid=$(pgrep -f "kubectl port-forward svc/metrics-grafana -n $namespace $grafana_local_port:80")

if [ -n "$port_forwarding_pid" ]; then
    echo "Port forwarding for Grafana is already running."
else
    echo "Port forwarding metrics-grafana to localhost:$grafana_local_port"
    kubectl port-forward svc/metrics-grafana -n $namespace $grafana_local_port:80 &
fi

