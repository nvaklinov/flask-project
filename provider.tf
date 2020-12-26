provider "aws" {

    profile = "default"
    region  = "eu-west-1"

}

provider "random" {

}

data "aws_caller_identity" "current" {} # used for accesing Account ID and ARN
