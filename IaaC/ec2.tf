############################### Cloud Provider #################################
provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }

    github = {
      source  = "integrations/github"
      version = ">= 5.9.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.4"
    }
  }
}

############################### EC2 Jenkins Deployment ####################################

resource "aws_network_interface" "interface" {
  #depends_on      = [module.eks]
  subnet_id = "subnet-01c1c970ab2ef985e" # element(module.vpc.public_subnets, 0)
  # private_ips     = [cidrhost(element(local.public_subnets, 0), 5)]
  security_groups = ["sg-043c450adcdac5cf4"] #aws_security_group.allow_tls.id
}


resource "aws_instance" "ec2" {
  depends_on    = [aws_network_interface.interface]
  ami           = "ami-090e0fc566929d98b"
  instance_type = "t3.micro" # local.instance_type
  user_data     = file("/home/ec2-user/environment/flask/IaaC/script.sh")
  

  network_interface {
    network_interface_id = aws_network_interface.interface.id
    device_index         = 0
  }

}
