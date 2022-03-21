variable "region_prod" {
  default = "eu-central-1"
}
variable "cidr_block_prod" {
  default = "10.0.0.0/16"
}
variable "vpc_name_prod" {
  default = "vpc-prod"
}

variable "subnet_name_prod" {
  default = "subnet-prod"
}
variable "route_prod" {
  default = "0.0.0.0/0"
}
variable "route_name_prod" {
  default = "rtb-prod"
}