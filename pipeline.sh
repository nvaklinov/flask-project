#!/bin/bash

REPO="662301180726.dkr.ecr.us-east-2.amazonaws.com/tsvetina-flask"

sudo pip install $(cat requirements.txt) 


nohup sudo python2 web.py &

sudo docker build -t "$REPO:${BUILD_NUMBER}" .

sudo docker push $REPO:${BUILD_NUMBER}
