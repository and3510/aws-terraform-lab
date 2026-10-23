# Provider apontando para o LocalStack (AWS emulada em http://localhost:4566).
# Credenciais fictícias: nada aqui toca a AWS real.
provider "aws" {
  region     = var.aws_region
  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = var.localstack_endpoint
    iam = var.localstack_endpoint
    s3  = var.localstack_endpoint
    sts = var.localstack_endpoint
  }

  default_tags {
    tags = {
      Project     = var.project
      Environment = "local"
      ManagedBy   = "terraform"
    }
  }
}
