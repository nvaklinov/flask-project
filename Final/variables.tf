variable "vpc" {
  default = "vpc-0f33bb620ccb65c4b"
}
variable "subnets" {
  default = ["subnet-05eedd743e6fe439b", "subnet-0d1ebbe4cfbbbd12c", "subnet-0c6b680d0742f141d"]
}
variable "role_arn" {
  default = "arn:aws:iam::366915744137:role/Admin"
}
variable "user" {
  default = "Terraform"
}
variable "domain" {
  default = "andydim.click"
}
variable "hosted_zone" {
  default = "Z04545712VDTBF0N6KJBF"
}
