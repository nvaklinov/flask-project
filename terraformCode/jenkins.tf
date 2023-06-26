resource "aws_network_interface" "example_nic" {
  depends_on      = [module.eks]
  subnet_id       = "subnet-040fa9f24303cc14d"
  security_groups = [data.aws_security_group.example_sg.id]
}

resource "aws_instance" "example" {
  depends_on             = [aws_network_interface.example_nic]
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_security_group.example_sg.id]
  user_data              = file("/home/ec2-user/nikFinaleTaske/terraformCode/adminUser.sh")
  iam_instance_profile   = "ecr-acces"

  tags = {
    Name = "example-instance"
  }
}