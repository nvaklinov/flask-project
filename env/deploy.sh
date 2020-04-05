#!/bin/bash

$(aws ecr get-login --region us-east-2 --no-include-email)

docker push $REPO:latest

kubectl create -f env/pod.yaml; status=$?
echo $status
