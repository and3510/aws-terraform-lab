provider "aws" {
  region = var.aws_region

  # Aplicadas automaticamente em todos os recursos que suportam tags
  default_tags {
    tags = {
      Project     = var.project
      Environment = var.environment
      Owner       = var.owner
      ManagedBy   = "terraform"
      Repository  = "aws-terraform-cli"
    }
  }
}
