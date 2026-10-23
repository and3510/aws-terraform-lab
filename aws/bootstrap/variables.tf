variable "aws_region" {
  description = "Região do bucket de state"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Prefixo do nome do bucket"
  type        = string
  default     = "ec2-train"
}

variable "noncurrent_version_retention_days" {
  description = "Dias para manter versões antigas do state"
  type        = number
  default     = 90
}
