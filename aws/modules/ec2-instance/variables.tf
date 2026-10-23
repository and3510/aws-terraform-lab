variable "name" {
  description = "Nome da instância (tag Name)"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI explícita. Se null, usa a Ubuntu LTS mais recente"
  type        = string
  default     = null
}

variable "ubuntu_release" {
  description = "Release Ubuntu usada na busca da AMI (ex: noble-24.04)"
  type        = string
  default     = "noble-24.04"
}

variable "architecture" {
  description = "Arquitetura da AMI (amd64 ou arm64)"
  type        = string
  default     = "amd64"

  validation {
    condition     = contains(["amd64", "arm64"], var.architecture)
    error_message = "architecture deve ser amd64 ou arm64."
  }
}

variable "key_name" {
  description = "Nome de um Key Pair já existente na AWS (null = sem chave SSH)"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet da instância (null = subnet default)"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "Security Groups associados"
  type        = list(string)
  default     = []
}

variable "associate_public_ip_address" {
  description = "Associa IP público à instância"
  type        = bool
  default     = true
}

variable "detailed_monitoring" {
  description = "Habilita CloudWatch detailed monitoring (cobrado à parte)"
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Tamanho do volume raiz em GiB"
  type        = number
  default     = 8
}

variable "user_data" {
  description = "Script cloud-init / user data"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionais"
  type        = map(string)
  default     = {}
}

variable "manage_metadata_options" {
  description = "Aplica a configuração de IMDSv2. Desligue apenas em emuladores sem suporte (ex: LocalStack)"
  type        = bool
  default     = true
}
