#!/bin/bash

echo "Installing Jenkins"
sudo yum update
sudo wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
aws eks get-token --cluster-name my-cluster
echo 'export KUBECONFIG=$KUBECONFIG:~/.kube/config-aws' >> ~/.bash_profile
aws eks update-kubeconfig --name my-cluster
sudo yum -y install awscli
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
sudo sh -c \"iptables-save > /etc/iptables.rules\"
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo apt-get -y install iptables-persistent
sudo ufw allow 8080
sudo cp -R /home/ec2-user/.aws /var/lib/jenkins
sudo shown -R jenkins ./
echo "Installing docker"
sudo yum update
sudo amazon-linux-extras enable docker
sudo yum -y install amazon-ecr-credential-helper
sudo yum -y install docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -aG docker ec2-user
sudo chmod 666 /var/run/docker.sock
chmod +x ./.docker
sudo systemctl start docker
sudo yum -y install git
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/arm64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo "Installing helm"
sudo yum -y update
curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm repo add stable https://charts.helm.sh/stable
sudo yum -y install awscli
