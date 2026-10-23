variable "aws_region" {
  description = "Região emulada"
  type        = string
  default     = "us-east-1"
}

variable "localstack_endpoint" {
  description = "Endpoint do LocalStack"
  type        = string
  default     = "http://localhost:4566"
}

variable "project" {
  description = "Nome do projeto (prefixo dos recursos)"
  type        = string
  default     = "ec2-train"
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI mock do LocalStack (as AMIs reais da Canonical não existem no emulador)"
  type        = string
  default     = "ami-785db401" # ubuntu-xenial-16.04 (mock)
}
