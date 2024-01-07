#!/usr/bin/env bash


minikube stop
minikube delete

MINIKUKE_LOCAL=$(which minikube)

sudo rm -rf ${MINIKUKE_LOCAL}
rm -rf ~/.minikube