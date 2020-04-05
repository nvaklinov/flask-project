!#/bin/bash
REPO="252803719446.dkr.ecr.us-east-2.amazonaws.com/test-repo"

cd env && docker build -t $REPO:latest .

cd ..
