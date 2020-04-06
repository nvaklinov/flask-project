#!/bin/bash

pip install -r requirements.txt && timeout 15 python web.py
status=$?

echo "Status:"$status

if [[ $status -eq 124  ]]
then echo "Success"
else echo "Error" && exit 1
fi

REPO="195245889165.dkr.ecr.eu-central-1.amazonaws.com/devops"
cd /home/ec2-user/Github/flask-project
docker build -t "$REPO:latest" .
$(aws ecr get-login --region eu-central-1 --no-include-email)
docker push $REPO:latest
