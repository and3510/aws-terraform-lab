output "server_public_ip" {
  description = "IP público da instância"
  value       = module.server.public_ip
}

output "server_id" {
  description = "ID da instância"
  value       = module.server.id
}

output "ssh_command" {
  description = "Comando para conectar via SSH"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${module.server.public_ip}"
}
