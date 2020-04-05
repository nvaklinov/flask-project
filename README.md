# Lyubo flask-project
#in env folder there are build and deploy scripts

build.sh is contenerizing the flask app via DOckerfile which is also in env 

deploy.sh is authenticating aws and is posting the docerized app into kubernetties pod created by env/pod.yaml
