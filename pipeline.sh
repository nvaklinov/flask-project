#!/bin/bash

REPO="152410580623.dkr.ecr.us-east-1.amazonaws.com/shuklev-flask-repo"

pip install -r requirements.txt && timeout 15 python web.py 
status=$?
echo "${JOB_NAME}"
if [[ $status -eq 124 ]]
then echo "SUCCESS!"
else echo "Something went wrong and it's Failed!" && exit 1
fi

docker build -t "$REPO:latest" .

$(aws ecr get-login --no-include-email --region us-east-1)

docker push $REPO:latest

cp /var/lib/jenkins/scripts/pod.yaml .
cp /var/lib/jenkins/scripts/script.sh /root/script.sh

kubectl delete -f pod.yaml
kubectl create -f pod.yaml; stat=$?

if [[ $stat !=0 ]]
then echo "Error while creating pod!"
else echo "Pod was created sucessfully!"
fi
