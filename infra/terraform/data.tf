data "aws_ami" "amazon-linux-2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_name
}

data "aws_caller_identity" "current" {}