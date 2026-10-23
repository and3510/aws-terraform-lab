output "server_id" {
  description = "ID da instância (simulada)"
  value       = module.server.id
}

output "server_public_ip" {
  description = "IP público (simulado, não responde a SSH)"
  value       = module.server.public_ip
}

output "security_group_id" {
  description = "ID do Security Group"
  value       = module.ssh_sg.id
}
