#!/bin/bash

#####JENKINS#######
yum update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins git -y


#######DOCKER############
yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins

sudo systemctl start jenkins
sudo systemctl enable jenkins

#sudo cat /var/lib/jenkins/secrets/initialAdminPassword 

####KUBECTLandHELM######
curl -LO https://dl.k8s.io/release/v1.23.6/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x kubectl
sudo mv kubectl /usr/bin
curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2

sudo yum install jenkins git jq -y
######CONFIG########


echo aws eks update-kubeconfig --region ${region} --name ${cluster} > 1.txt
mkdir /var/lib/jenkins/.kube/
cp ~/.kube/config /var/lib/jenkins/.kube/
chown -R jenkins: /var/lib/jenkins/
chmod 600 /var/lib/jenkins/.kube/config
chmod u+x /var/lib/jenkins/.kube

echo 'OUT=$(aws sts assume-role --role-arn arn:aws:iam::699509601278:role/flask-role --role-session-name AWSCLI-Session) \
&& export AWS_ACCESS_KEY_ID=$(echo $OUT | jq -r '.Credentials''.AccessKeyId') \
&& export AWS_SECRET_ACCESS_KEY=$(echo $OUT | jq -r '.Credentials''.SecretAccessKey') \
&& export AWS_SESSION_TOKEN=$(echo $OUT | jq -r '.Credentials''.SessionToken') \
&& export AWS_DEFAULT_REGION="eu-central-1" \
&& aws sts get-caller-identity' > /var/lib/jenkins/assume_role.sh  


##############JENKINS USER ##############
public_ip=$(curl -sS ifconfig.me)
url=http://${public_ip}:8080
password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)


# NEW ADMIN CREDENTIALS URL ENCODED USING PYTHON
username=$(python -c "import urllib;print urllib.quote(raw_input(), safe='')" <<< "admin")
new_password=$(python -c "import urllib;print urllib.quote(raw_input(), safe='')" <<< "123456")
fullname=$(python -c "import urllib;print urllib.quote(raw_input(), safe='')" <<< "full name")
email=$(python -c "import urllib;print urllib.quote(raw_input(), safe='')" <<< "hello@world.com")

# GET THE CRUMB AND COOKIE
cookie_jar="$(mktemp)"
full_crumb=$(curl -u "admin:$password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})


# MAKE THE REQUEST TO CREATE AN ADMIN USER
curl -X POST -u "admin:$password" $url/setupWizard/createAdminUser \
        -H "Connection: keep-alive" \
        -H "Accept: application/json, text/javascript" \
        -H "X-Requested-With: XMLHttpRequest" \
        -H "$full_crumb" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        --cookie $cookie_jar \
        --data-raw "username=$username&password1=$new_password&password2=$new_password&fullname=$fullname&email=$email&Jenkins-Crumb=$only_crumb&json=%7B%22username%22%3A%20%22$username%22%2C%20%22password1%22%3A%20%22$new_password%22%2C%20%22%24redact%22%3A%20%5B%22password1%22%2C%20%22password2%22%5D%2C%20%22password2%22%3A%20%22$new_password%22%2C%20%22fullname%22%3A%20%22$fullname%22%2C%20%22email%22%3A%20%22$email%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D&core%3Aapply=&Submit=Save&json=%7B%22username%22%3A%20%22$username%22%2C%20%22password1%22%3A%20%22$new_password%22%2C%20%22%24redact%22%3A%20%5B%22password1%22%2C%20%22password2%22%5D%2C%20%22password2%22%3A%20%22$new_password%22%2C%20%22fullname%22%3A%20%22$fullname%22%2C%20%22email%22%3A%20%22$email%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D"


# DOWNLOAD AND INSTALL REQUIRED MODULES
cookie_jar="$(mktemp)"
full_crumb=$(curl -u "$username:$new_password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})


curl -X POST -u "$username:$new_password" $url/pluginManager/installPlugins \
    -H 'Connection: keep-alive' \
    -H 'Accept: application/json, text/javascript, */*; q=0.01' \
    -H 'X-Requested-With: XMLHttpRequest' \
    -H "$full_crumb" \
    -H 'Content-Type: application/json' \
    -H 'Accept-Language: en,en-US;q=0.9,it;q=0.8' \
    --cookie $cookie_jar \
    --data-raw "{'dynamicLoad':true,'plugins':['cloudbees-folder','antisamy-markup-formatter','build-timeout','credentials-binding','timestamper','ws-cleanup','ant','gradle','workflow-aggregator','github-branch-source','pipeline-github-lib','pipeline-stage-view','git','ssh-slaves','matrix-auth','pam-auth','ldap','email-ext','mailer'],'Jenkins-Crumb':'$only_crumb'}"

#Confirm Jenkins URL
url_urlEncoded=$(python -c "import urllib;print urllib.quote(raw_input(), safe='')" <<< "$url")
cookie_jar="$(mktemp)"
full_crumb=$(curl -u "$username:$new_password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})


curl -X POST -u "$username:$new_password" $url/setupWizard/configureInstance \
        -H 'Connection: keep-alive' \
        -H 'Accept: application/json, text/javascript, */*; q=0.01' \
        -H 'X-Requested-With: XMLHttpRequest' \
        -H "$full_crumb" \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -H 'Accept-Language: en,en-US;q=0.9,it;q=0.8' \
        --cookie $cookie_jar \
        --data-raw "rootUrl=$url_urlEncoded%2F&Jenkins-Crumb=$only_crumb&json=%7B%22rootUrl%22%3A%20%22$url_urlEncoded%2F%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D&core%3Aapply=&Submit=Save&json=%7B%22rootUrl%22%3A%20%22$url_urlEncoded%2F%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D"
