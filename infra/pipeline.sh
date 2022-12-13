#!/bin/bash

set -e

#########BUILD############

image_name=058302395964.dkr.ecr.eu-central-1.amazonaws.com/flask
docker build -t $image_name:$GIT_COMMIT .
docker run -dit -p 5000:5000 $image_name:$GIT_COMMIT
sleep 5

##########TEST#############
curl localhost:5000
exit_status=$?

if [[ $exit_status == 0 ]]
then echo "SUCCESSFUL TESTS" && docker stop $(docker ps -a -q)
else echo "FAILED TESTS" && docker stop $(docker ps -a -q) && exit 1
fi

#########PUSH##############
docker login -u AWS https://058302395964.dkr.ecr.eu-central-1.amazonaws.com -p $(aws ecr get-login-password --region eu-central-1)
docker push $image_name:$GIT_COMMIT

########DEPLOY############

deploy() {
 local env=$1
 local tag=$2

helm upgrade flask helm/ --atomic --wait --install --namespace $env --create-namespace --set deployment.tag=$tag --set deployment.env=$env
}

if [[ $GIT_BRANCH == "origin/master" ]]
then deploy prod $GIT_COMMIT
elif [[ $GIT_BRANCH == "origin/development" ]]
then deploy dev $GIT_COMMIT
elif [[ $GIT_BRANCH == "origin/uat" ]]
then deploy uat $GIT_COMMIT
else echo "Branch I cannot deploy" && exit 1
fi
