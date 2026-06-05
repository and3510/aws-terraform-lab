provider "aws" {
  region = var.aws_region
}

resource "random_pet" "server_username" {
  length    = 2
  separator = "_"
}

resource "random_password" "server_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# (O resto continua igual com o Security Group e o aws_instance)
# The Firewall to allow SSH
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_terraform"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# WE DELETED THE AWS_KEY_PAIR BLOCK HERE

resource "aws_instance" "my_server" {
  ami           = "ami-04b70fa74e45c3917" 
  instance_type = var.instance_type
  
  # Tell AWS to use the key that already exists in your account
  key_name      = "anderson-novo" 
  
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name  = "My-Student-EC2"
    Owner = random_pet.server_username.id 
  }
}