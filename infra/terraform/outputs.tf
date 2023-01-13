output "public_ip" {
  description = "Jenkins URL"
  value       = "${aws_instance.ec2.public_ip}:8080"
}

output "ecr_url" {
  description = "ECR URL"
  value       = aws_ecr_repository.ecr.repository_url
}
