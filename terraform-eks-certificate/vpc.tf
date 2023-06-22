module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                    = "my-vpc"
  cidr                    = "10.0.0.0/16"
  map_public_ip_on_launch = true

  azs            = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
