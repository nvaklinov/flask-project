#!/bin/bash

REPO="649543754069.dkr.ecr.us-east-2.amazonaws.com/flask-repo"

pip install -r requirements.txt && timeout 30 python web.py
status=$?
if [[ $status -eq 124 ]]
then echo "SUCCESS"
else echo "OMG, it failed again" && exit 1
fi

docker build -t "$REPO:latest" .

$(aws ecr get-login --no-include-email --region us-east-2)

docker push $REPO:latest

cp /var/lib/jenkins/scripts/pod.yaml .

kubectl delete pod flask-app

kubectl create -f pod.yaml; stat=$?

if [[ $stat != 0 ]] 
then echo "FATAL ERROR"
else echo "YES"
fi
