variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Nome do projeto (prefixo dos recursos)"
  type        = string
  default     = "ec2-train"
}

variable "environment" {
  description = "Nome do ambiente"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Responsável pelos recursos (tag Owner)"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key Pair existente na AWS para acesso SSH"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "CIDRs autorizados a acessar a porta 22 (ex: [\"203.0.113.10/32\"])"
  type        = list(string)

  validation {
    condition     = !contains(var.allowed_ssh_cidrs, "0.0.0.0/0")
    error_message = "Não exponha SSH para 0.0.0.0/0. Use o seu IP (/32) ou o range da sua rede."
  }
}

variable "vpc_id" {
  description = "VPC a usar (null = VPC default)"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet a usar (null = subnet default)"
  type        = string
  default     = null
}
