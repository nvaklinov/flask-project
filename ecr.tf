resource "aws_ecr_repository" "jenkins" {
  name                 = "final_project2"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
