# EC2 instance:

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = locals.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name      = aws_key_pair.deployer.key_name
  user_data     = <<EOF
    #!/bin/bash

    # Installing Helm #
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh

    # Installing Kind #
    [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind

    # Installing Kubectl #
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    # Installing Jenkins #
    yum update –y
    wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    yum upgrade
    amazon-linux-extras install java-openjdk11 -y
    yum install jenkins git -y
    yum install jenkins -y
    systemctl enable jenkins
    systemctl start jenkins

    # Install Docker #
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    usermod -aG docker jenkins
    systemctl enable jenkins
    systemctl start jenkins


  EOF

  tags = {
    Name = "${local.name}-ec2"
  }
}


# Security Groups

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "sg" {
  name        = "${local.name}-sg"
  description = "Allow HTTPS to web server"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTPS ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# ECR Reposity

resource "aws_ecr_repository" "ecre3" {
  name                 = ""${local.name}-ecr""
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}


# AWS Keys

resource "aws_key_pair" "deployer" {
 key_name   = "key-pair"
 public_key = tls_private_key.key.public_key_openssh
}

resource "tls_private_key" "key" {
 algorithm = "RSA"
 rsa_bits  = 2048
}


# Locals

locals {
  name   = "final"
  my_ip  = "0.0.0.0/0"
  region = "eu-central-1"
  tags = {
    environment                                   = "prj"
    team                                          = "akk"
    "kubernetes.io/role/elb"                      = 1
    "kubernetes.io/cluster/${local.name}-cluster" = "owned"
  }
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  azs            = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_cidr       = "10.0.0.0/16"
  instance_type  = "t3.micro"
}
