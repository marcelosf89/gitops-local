#!/usr/bin/env bash
path=$PWD/configurations/third_parties/mysql
namespace=mysql-server
name=mysql-server

mkdir -p $$path/.ignore
cp $PWD/applications/web/src/db/init.sql $path/.ignore/init.sql

kubectl create namespace $namespace &> /dev/null

helm template $path > $path/.ignore/db-init.yaml
kubectl apply -f $path/.ignore/db-init.yaml

if helm status $name -n $namespace &> /dev/null; then
    helm_action="install"
else
    helm_action="upgrade"
fi

helm $helm_action $name -n $namespace oci://registry-1.docker.io/bitnamicharts/mysql --values $path/values.yaml
