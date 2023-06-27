# resource "aws_secretsmanager_secret" "devops_secret" {
#   name = "devops-secret6"
# }

# resource "aws_secretsmanager_secret_version" "devops_secret_version" {
#   secret_id     = aws_secretsmanager_secret.devops_secret.id
#   #secret_string = "{\"ENV\": \"DevOps\"}"
# }