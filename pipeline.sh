#!/bin/bash

REPO="678186249470.dkr.ecr.eu-central-1.amazonaws.com/flask"

pip install -r requirements.txt && timeout 10 python web.py

status=$?
echo $status
if [[ $status -eq 124 ]]
then echo "SUCCESS"
else echo "FAILED" && exit 1	
fi

docker build -t "$REPO:latest" .

$(aws ecr get-login --region eu-central-1 --no-include-email)

docker push $REPO:latest


kubectl create -f pod.yaml; stat=$?

if [[ $stat != 0 ]]
then echo "ERROR"
else echo "IT WORKS!!!"
fi
