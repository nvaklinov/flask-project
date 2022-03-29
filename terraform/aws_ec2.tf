data "aws_ami" "amazon-linux-2" {
 most_recent = true
 
 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
owners = ["amazon"]
}

resource "aws_security_group" "this" {
  name        = "allow_jenkins"
  description = "allow_inbound_traffic"
  vpc_id      = "vpc-0c8147f52bb634b83"

  ingress {
    description      = "TLS from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

 ingress {
    description      = "SSH Connection"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "jenkins_security_group"
  }
}


resource "aws_instance" "for_jenkins" {

 ami                         = data.aws_ami.amazon-linux-2.id
 associate_public_ip_address = true
 instance_type               = var.instance
 vpc_security_group_ids      = [aws_security_group.this.id]
 subnet_id                   = var.subnet
 tags = {
    Name = "Jenkins_Server"
  }
}
