# outputs.tf

output "server_public_ip" {
  description = "The public IP address of the new EC2 instance"
  value       = aws_instance.my_server.public_ip
}

output "generated_username" {
  description = "The randomly generated username"
  value       = random_pet.server_username.id
}

output "generated_password" {
  description = "The randomly generated password"
  value       = random_password.server_password.result
  sensitive   = true # This hides the password from the terminal screen
}