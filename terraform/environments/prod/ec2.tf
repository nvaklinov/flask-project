data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amzn-2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}
resource "aws_security_group" "allow_jenkins"{
  name = "allow_jenkins"
  description = "Allow inbound traffic"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port = 8080
    protocol  = "tcp"
    to_port   = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  protocol = "tcp"
  Name = "jenkins"
}
resource "aws_instance" "jenkins" {
  ami = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
}

