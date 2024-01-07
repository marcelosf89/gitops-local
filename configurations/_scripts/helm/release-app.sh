#!/usr/bin/env bash

app=$1
environment=$2
version=$3

path=$PWD/applications/$app/_release

mkdir -p $path/.ignore

cp $path/helm/Chart.yaml $path/.ignore/Chart.yaml
cp -a $path/helm/templates/. $path/.ignore/templates
cp -a $path/helm/env/$environment/. $path/.ignore/templates/
rm $path/.ignore/templates/values.yaml

cp $path/helm/env/$environment/values.yaml $path/.ignore/values.yaml	

helm template $path/.ignore/ --set image.tag=$version --values $path/.ignore/values.yaml > $path/env/$environment/deploy.yaml

