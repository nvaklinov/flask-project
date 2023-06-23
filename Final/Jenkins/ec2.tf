# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

//AWS EC2 #1
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow Jenkins Traffic"
  vpc_id      = "vpc-0f33bb620ccb65c4b"

  ingress {
    description = "Allow from Personal CIDR block"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from Personal CIDR block"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Jenkins SG"
  }
}

resource "aws_instance" "web" {
  ami             = "ami-09db9d79b41ec058e"
  instance_type   = "t3.small"
  key_name        = "TerraformNEME"
  security_groups = [aws_security_group.jenkins_sg.name]

  provisioner "file" {
    source      = "scripts/"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh /tmp/plugins.sh /tmp/jenkins.groovy",
      "bash /tmp/script.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./TerraformNEME.pem")
    host        = self.public_ip
  }

  tags = {
    Name = "Jenkins"
  }
}