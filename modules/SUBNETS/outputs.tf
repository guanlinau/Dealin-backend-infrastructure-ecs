output "pub_subnet_1" {
  value = aws_subnet.pub_subnet_1
}

output "pub_subnet_2" {
    value = aws_subnet.pub_subnet_2
  
}
output "pri_subnet_1" {
    value = aws_subnet.pri_subnet_1
  
}
output "pri_subnet_2" {
    value = aws_subnet.pri_subnet_2
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [
    aws_subnet.pub_subnet_1.id,
    aws_subnet.pub_subnet_2.id
  ]
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [
    aws_subnet.pri_subnet_1.id,
    aws_subnet.pri_subnet_2.id
  ]
}