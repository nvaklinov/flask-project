#!bin/bash/

helm upgrade flaskapp flaskapp/ --install --atomic --wait --set deployment.tag=$GIT_COMMIT
