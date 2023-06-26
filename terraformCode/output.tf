output "public_ip" {
  description = "Jenkins URL"
  value       = "${aws_instance.example.public_ip}:8080"
}