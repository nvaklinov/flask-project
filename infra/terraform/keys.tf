resource "random_string" "random" {
  length  = 5
  special = false
  keepers = {
    "secret" = aws_key_pair.deployer.id
  }
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = "${local.name}-key"
  public_key = tls_private_key.key.public_key_openssh
}

resource "aws_secretsmanager_secret" "secret" {
  count = 2
  name  = count.index == 1 ? "${random_string.random.result}-${local.name}_private_key" : "${random_string.random.result}-${local.name}_public_key"
}

resource "aws_secretsmanager_secret_version" "secret" {
  count         = 2
  secret_id     = count.index == 1 ? aws_secretsmanager_secret.secret[count.index].id : aws_secretsmanager_secret.secret[count.index].id
  secret_string = count.index == 1 ? tls_private_key.key.private_key_pem : tls_private_key.key.public_key_openssh
}
