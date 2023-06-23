variable "vpc" {
  value = "vpc-0f33bb620ccb65c4b"
}
variable "subnets" {
  value = ["subnet-05eedd743e6fe439b", "subnet-0d1ebbe4cfbbbd12c", "subnet-0c6b680d0742f141d"]
}
variable "role_arn" {
  value = "arn:aws:iam::366915744137:role/Admin"
}
variable "user" {
  value = "Terraform"
}
variable "domain" {
  value = "andydim.click"
}
variable "hosted_zone" {
  value = "Z04545712VDTBF0N6KJBF"
}