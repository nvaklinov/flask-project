#!/bin/bash

REPO="533391766968.dkr.ecr.us-east-1.amazonaws.com/zlatin-flask"

pip install -r requirements.txt && timeout 15 python web.py 
status=$?
echo "${JOB_NAME}"
if [[ $status -eq 124 ]]
then echo "SUCCESS!"
else echo "Houston we have a problem!" && exit 1
fi

docker build -t "$REPO:latest" .

$(aws ecr get-login --no-include-email --region us-east-1)

docker push $REPO:latest

cp /var/lib/jenkins/scripts/pod.yaml .

kubectl delete -f pod.yaml
kubectl create -f pod.yaml; stat=$?

if [[ $stat !=0 ]]
then echo "Error while creating pod!"
else echo "Pod created sucessfully!"
fi
