#!/usr/bin/env bash

# Install minikube

# Get processor and OS architecture
ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ "$OS" != "darwin" ] && [ "$OS" != "linux" ]; then
    echo "OS $OS not supported"
    exit 1
fi

echo "Operating system: ${OS}-${ARCH}"

# Download minikube
echo "Installing minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-${OS}-${ARCH}
sudo install minikube-${OS}-${ARCH} /usr/local/bin/minikube


