form{
  required_providers{
    aws{
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#Configure the AWS Provider
provider "aws"{
  region = var.region
}

module "vpc" {
  source = "modules/vpc"
}