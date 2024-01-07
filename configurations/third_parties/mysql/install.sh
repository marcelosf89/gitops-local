#!/usr/bin/env bash
path=$PWD/configurations/third_parties/mysql

mkdir -p $$path/.ignore
cp $PWD/applications/web/src/db/init.sql $path/.ignore/init.sql

kubectl create namespace mysql-server

helm template $path > $path/.ignore/db-init.yaml
kubectl apply -f $path/.ignore/db-init.yaml

helm install mysql-server -n mysql-server oci://registry-1.docker.io/bitnamicharts/mysql --values $path/values.yaml
