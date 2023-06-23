#!/bin/bash

set -euo pipefail


####### INSTALL & ENABLE JENKINS #######

sudo yum update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y
sudo yum install jq -y


####### DISABLE FIRST TIME LOGIN & CREATE USER #######

init_dir="/var/lib/jenkins/init.groovy.d"
default_conf="/etc/sysconfig/jenkins"
cli_url="http://localhost:8080/jnlpJars"
script="/tmp/jenkins.groovy"

echo "Creating init dir and adding args..."
sudo sed -i 's/JENKINS_ARGS=""/JENKINS_ARGS="-Djenkins.install.runSetupWizard=false -Djenkins.install.UpgradeWizardState=disabled"/g' "${default_conf}"
sudo mkdir "${init_dir}"
sudo cp "${script}" "${init_dir}"

sudo chown jenkins:jenkins "${init_dir}"

echo "Starting Jenkins and downloading cli...."
sudo systemctl enable --now jenkins
sudo systemctl status jenkins
sudo wget "${cli_url}"/jenkins-cli.jar

echo "Installing plugins..."
echo

bash /tmp/plugins.sh


echo "Removing groovy script and JENKINS_ARGS..."
echo
sudo rm -rf "${init_dir}"
sudo sed -i 's/JENKINS_ARGS="-Djenkins.install.runSetupWizard=false -Djenkins.install.UpgradeWizardState=disabled"/JENKINS_ARGS=""/g' "${default_conf}"
sudo sed -i 's/<denyAnonymousReadAccess>false</<denyAnonymousReadAccess>true</g' /var/lib/jenkins/config.xml
echo

echo
echo "Restarting Jenkins after plugins install..."
sudo systemctl restart jenkins


echo "DONE!"