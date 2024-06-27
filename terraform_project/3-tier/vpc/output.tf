output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
    description = "the id of the public subnet"
    value = aws_subnet.public[count.index].id
}

output "private_subnet_id" {
    description = "the id of the private subnet"
    value = aws_subnet.private[count.index].id
}