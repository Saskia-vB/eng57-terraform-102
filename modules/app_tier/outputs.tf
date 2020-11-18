output "security_group_id" {
  description = "id of security group from app"
  value = aws_security_group.sg_app.id
}

output "subpublic_cidr_block" {
  description = "cidr block of pub subnet"
  value = aws_subnet.sub_public_again.cidr_block
}

output "subpublic_id" {
  description = "pub subnet id"
  value = aws_subnet.sub_public_again.id
}
