
#!/bin/bash

REPO="206354132017.dkr.ecr.us-east-2.amazonaws.com/test-repo"

sudo pip install -r requirements.txt && nohup sudo python web.py &

nohub sudo python web.py &

sudo docker build -t "$REPO:${BUILD_NUMBER}"

sudo docker push "$REPO:${BUILD_NUMBER}"
