variable "region_prod" {
  default = "eu-central-1"
}
variable "cidr_block_prod" {
  default = "10.0.0.0/16"
}
variable "vpc_name_prod" {
  default = "vpc-prod"
}
variable "cidr_subnet_prod" {
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
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