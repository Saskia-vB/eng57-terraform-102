output "db_private_ip" {
  description = "db private ip"
  value = aws_instance.db.private_ip
}

output "private_subnet_id" {
  description = "id of private subnet for db"
  value = aws_subnet.subprivate.id
}
