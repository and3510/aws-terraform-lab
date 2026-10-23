# Por padrão o state fica local. Para usar remote state no S3:
#   1. Provisione o bucket com aws/bootstrap
#   2. Copie backend.hcl.example para backend.hcl e ajuste
#   3. Descomente o bloco abaixo e rode `make init` (ou `terraform init -migrate-state -backend-config=backend.hcl`)
#
# terraform {
#   backend "s3" {}
# }
