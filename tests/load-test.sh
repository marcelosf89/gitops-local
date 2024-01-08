#!/usr/bin/env bash

path=$PWD/tests
host=localhost:9000

# Get all files
files=$(find $path/load -type f -name "*.js")

# Run k6 command for each file
for file in $files; do
    k6 run -o experimental-prometheus-rw --vus 10 --duration 4m --env HOSTNAME=$host "$file"
done
