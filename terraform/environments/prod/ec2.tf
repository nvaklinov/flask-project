data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}
resource "aws_security_group" "allow_jenkins"{
  name = "allow_jenkins"
  description = "Allow inbound traffic"
  vpc_id = module.vpc.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "jenkins_server"
  }
}
resource "aws_instance" "jenkins" {
  ami = data.aws_ami.amazon-2.id
  associate_public_ip_address = true
  user_data       = file("installation.sh")
  instance_type = "t2.large"
  vpc_security_group_ids      = [aws_security_group.allow_jenkins.id]
  tags = {
    Name = "jenkins_server"
  }
}

