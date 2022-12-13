#!/bin/bash

set -e

#########BUILD############

image_name=999999999.dkr.ecr.eu-central-1.amazonaws.com/pragma-app
docker build -t $image_name:$GIT_COMMIT
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
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password_stdin 999999999.dkr.ecr.eu-central-1.amazonaws.com

docker push $image_name:$GIT_COMMIT

########DEPLOY############

deploy() {
 local env=$1
 local tag=$2

helm upgrade flask helm/ --atomic --wait --install --namespace $env --create-namespace --set deployment.tag=$tag --set deployment.env=$env
}

if [[ $GIT_BRANCH == "origin/main" ]]
then deploy prod $GIT_COMMIT
elif [[ $GIT_BRANCH == "origin/dev" ]]
then deploy dev $GIT_COMMIT
elif [[ $GIT_BRANCH == "origin/stage" ]]
then deploy stage $GIT_COMMIT
else echo "Branch I cannot deploy" && exit 1
fi
