variable "region" {
  default = "eu-central-1"
}
variable "cidr_block" {
  default = "10.0.0.0/16"
}
variable "vpc_name" {
  default = "vpc-dev"
}
variable "cidr_subnet" {
  default = "10.0.0.0/24"
}
variable "subnet_name" {
  default = "subnet-dev"
}
variable "route" {
  default = "0.0.0.0/0"
}
variable "route_name" {
  default = "rtb-dev"
}