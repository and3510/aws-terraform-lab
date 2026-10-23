output "id" {
  description = "ID da instância"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "IP público da instância"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "IP privado da instância"
  value       = aws_instance.this.private_ip
}

output "public_dns" {
  description = "DNS público da instância"
  value       = aws_instance.this.public_dns
}

output "ami_id" {
  description = "AMI utilizada"
  value       = aws_instance.this.ami
}
