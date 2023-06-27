variable "subnet_ids" {
  default = ["subnet-040fa9f24303cc14d", "subnet-00aab7218a8c00118", "subnet-06009a3069f1f7137"]
}
variable "vpc_id" {
  default = "vpc-06a4fcdc531871a72"
}
variable "domain" {
  default = "baevsociety.com"
}
variable "hosted_zone_id" {
  default = "Z034907326K9JSEXLN78Z"
}

variable "region" {
  default = "eu-central-1"
}