output "id" {
  description = "ID do Security Group"
  value       = aws_security_group.this.id
}

output "arn" {
  description = "ARN do Security Group"
  value       = aws_security_group.this.arn
}
