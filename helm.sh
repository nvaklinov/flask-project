#!bin/bash/

helm upgrade flaskapp helm/ --install --atomic --wait --set deployment.tag=$GIT_COMMIT
