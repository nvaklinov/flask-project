resource "aws_ecr_repository" "this" {
  name                 = "flaskapp"
  image_tag_mutability = "MUTABLE"

}
