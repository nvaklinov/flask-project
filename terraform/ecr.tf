resource "aws_ecr_repository" "foo" {
  name                 = "flaskapp"
  image_tag_mutability = "MUTABLE"
}
