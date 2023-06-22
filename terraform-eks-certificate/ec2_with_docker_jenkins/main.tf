provider "aws" {
  region = "eu-central-1"
}
resource "aws_default_vpc" "default" {}

resource "aws_instance" "jenkins" {
  ami                         = "ami-0094635555ed28881"
  vpc_security_group_ids      = [aws_security_group.web.id]
  instance_type               = "t3.large"
  user_data                   = file("user_data.sh")
  user_data_replace_on_change = true
  key_name                    = "test2"
  tags = {
    Name  = "Jenkins server"
    Owner = "Daniel Kotev"
  }

  lifecycle {
    create_before_destroy = true

  }
}

resource "aws_security_group" "web" {
  name        = "jenkins_docker"
  description = "security group for my webserver"
  vpc_id      = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = ["9090", "8080", "5000", "22"]
    content {
      description = "Allow port Http"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow all ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
output "website_url" {
  value = join("", ["https://", aws_instance.jenkins.public_dns, ":", "8080"])

}
