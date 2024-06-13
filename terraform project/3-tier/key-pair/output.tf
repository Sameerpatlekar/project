output "key_name" {
  value = aws_key_pair.generated_key.key_name
}

output "private_key_pem" {
  value     = tls_private_key.key-pair.private_key_pem
  sensitive = true
}