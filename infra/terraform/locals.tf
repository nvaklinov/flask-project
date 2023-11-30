locals {
  name   = "nikpragm"
  my_ip  = "0.0.0.0/0"
  region = "eu-central-1"
  tags = {
    environment                                   = "dev"
    team                                          = "devops"
    "kubernetes.io/role/elb"                      = 1
    "kubernetes.io/cluster/${local.name}-cluster" = "owned"
  }
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  azs            = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_cidr       = "10.0.0.0/16"
  instance_type  = "t2.large"
}
