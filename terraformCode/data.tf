data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_name
}

data "aws_caller_identity" "current" {}

data "aws_security_group" "example_sg" {
  id = "sg-0907c44ee589181ba"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}