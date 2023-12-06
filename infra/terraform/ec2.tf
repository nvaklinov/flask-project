resource "aws_network_interface" "interface" {
  depends_on      = [module.vpc]
  subnet_id       = element(module.vpc.public_subnets, 0)
  private_ips     = [cidrhost(element(local.public_subnets, 0), 5)]
  security_groups = [aws_security_group.allow_tls.id]
}


resource "aws_instance" "ec2" {
  depends_on    = [aws_network_interface.interface, module.eks]
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = local.instance_type
  user_data     = <<EOF
        #!/bin/bash

        ###########JENKINS###############
        yum update -y
        sudo wget -O /etc/yum.repos.d/jenkins.repo \
        https://pkg.jenkins.io/redhat-stable/jenkins.repo
        sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
        yum upgrade -y
        amazon-linux-extras install java-openjdk11 -y
        yum install jenkins git jq -y

        ###########DOCKER################
        yum install -y docker
        systemctl start docker
        systemctl enable docker
        usermod -aG docker jenkins
        systemctl enable jenkins
        systemctl start jenkins

        ############KUBECTLandHELM##########
        curl -LO https://dl.k8s.io/release/v1.23.6/bin/linux/amd64/kubectl
        install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2

        #############INSTALL ASSUME ROLE SCRIPT###########
        echo '#!/bin/bash' > /var/lib/jenkins/assume_role.sh
        echo '' >> /var/lib/jenkins/assume_role.sh
        echo 'OUT=$(aws sts assume-role --role-arn "${aws_iam_role.role2.arn}" --role-session-name AWSCLI-Session)' >> /var/lib/jenkins/assume_role.sh
        echo '' >> /var/lib/jenkins/assume_role.sh
        echo 'export AWS_ACCESS_KEY_ID=$(echo $OUT | jq -r ".Credentials.AccessKeyId")' >> /var/lib/jenkins/assume_role.sh
        echo 'export AWS_SECRET_ACCESS_KEY=$(echo $OUT | jq -r ".Credentials.SecretAccessKey")' >> /var/lib/jenkins/assume_role.sh
        echo 'export AWS_SESSION_TOKEN=$(echo $OUT | jq -r ".Credentials.SessionToken")' >> /var/lib/jenkins/assume_role.sh
        echo "export AWS_DEFAULT_REGION=${local.region}" >> /var/lib/jenkins/assume_role.sh
        echo '' >> /var/lib/jenkins/assume_role.sh
        chmod +x /var/lib/jenkins/assume_role.sh
        usermod -s /bin/bash jenkins
        echo -e "123\n123" | sudo passwd jenkins
    EOF

  iam_instance_profile = aws_iam_instance_profile.profile.name
  network_interface {
    network_interface_id = aws_network_interface.interface.id
    device_index         = 0
  }
  tags = {
    Name = "Jenkins"
  }
}