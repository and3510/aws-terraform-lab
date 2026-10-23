variable "name" {
  description = "Nome base do Security Group"
  type        = string
}

variable "description" {
  description = "Descrição do Security Group"
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "VPC onde o SG será criado (null = VPC default da região)"
  type        = string
  default     = null
}

variable "ingress_rules" {
  description = "Regras de entrada"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.ingress_rules : alltrue([for c in r.cidr_blocks : can(cidrhost(c, 0))])])
    error_message = "Todos os cidr_blocks devem ser CIDRs IPv4 válidos."
  }
}

variable "allow_all_egress" {
  description = "Libera todo o tráfego de saída"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais"
  type        = map(string)
  default     = {}
}
