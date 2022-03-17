resource "aws_ecr_repository" "flask"{
  name = "flaskapp"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}