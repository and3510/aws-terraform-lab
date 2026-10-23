# aws-terraform-lab 🚀

Infraestrutura como Código com **Terraform** para **AWS**: módulos reutilizáveis e ambientes isolados (AWS real e laboratório local com LocalStack).

O ambiente `aws/environments/dev` provisiona uma instância EC2 Ubuntu com Security Group restrito, IMDSv2 obrigatório e disco criptografado.

## 📁 Estrutura

```
.
├── aws/
│   ├── bootstrap/              # Bucket S3 para remote state (state local)
│   ├── modules/
│   │   ├── ec2-instance/       # EC2 com hardening (IMDSv2, EBS criptografado, AMI dinâmica)
│   │   └── security-group/     # SG com regras declarativas
│   └── environments/
│       ├── dev/                # Root module: AWS real
│       └── local/              # Root module: AWS emulada (LocalStack), custo zero
├── .tflint.hcl
├── .pre-commit-config.yaml
└── Makefile                    # Atalhos opcionais: make <alvo> ENV=<ambiente>
```

**Convenção:** `modules/` contém blocos genéricos e sem provider configurado; `environments/<env>/` são os root modules, onde ficam provider, backend, versões e valores. Novo ambiente = copiar `dev/` para `staging/` ou `prod/` e ajustar o `terraform.tfvars`.

## ✅ Pré-requisitos

- Terraform >= 1.10
- AWS CLI configurado (`aws configure`, `aws sso login` ou variáveis `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`/`AWS_SESSION_TOKEN`)
- Um Key Pair existente na região (ex: `anderson-novo`)
- Opcional: `tflint`, `pre-commit`

## 🚀 Uso rápido

```bash
# 1. Variáveis do ambiente
cp aws/environments/dev/terraform.tfvars.example aws/environments/dev/terraform.tfvars
# edite: owner, key_name, allowed_ssh_cidrs (seu IP: curl -s https://checkip.amazonaws.com)

# 2. Ciclo de vida
make init          # ENV=dev é o padrão
make plan
make apply
make output

# 3. Conectar
$(terraform -chdir=aws/environments/dev output -raw ssh_command)

# 4. Limpar (evita custos)
make destroy
```

`make help` lista todos os alvos. O `make` é opcional: dentro de `aws/environments/<env>/` os comandos `terraform init|plan|apply|destroy` funcionam normalmente.

## 🧪 Laboratório local (sem AWS, sem custo)

O ambiente `aws/environments/local` usa os **mesmos módulos**, mas aponta o provider para o [LocalStack](https://github.com/localstack/localstack), que emula a API da AWS num container Docker. Não precisa de conta nem de credenciais.

```bash
make local-up                      # sobe o LocalStack em localhost:4566

cd aws/environments/local
terraform init
terraform plan
terraform apply                    # "cria" SG + EC2 no emulador
terraform state list
terraform destroy

cd - && make local-down            # derruba o emulador (descarta tudo)
```

Limitações do emulador:

- A EC2 é só um registro na API (modo `mock`). Não existe VM real, então não dá para conectar por SSH.
- As AMIs reais da Canonical não existem lá. Por isso o ambiente usa uma AMI mock fixa (`ami_id`).
- O LocalStack não implementa a API de IMDSv2. Por isso o ambiente local usa `manage_metadata_options = false`; na AWS real o IMDSv2 continua obrigatório.

Serve para treinar o fluxo do Terraform (plan, apply, state, módulos, refatoração) antes de rodar em `dev`.

## 🗄️ Remote state (recomendado)

Por padrão o state é local. Para trabalho em equipe/CI, use S3 com lock nativo (`use_lockfile`, sem DynamoDB):

```bash
make bootstrap                                   # cria bucket versionado, criptografado e privado
terraform -chdir=aws/bootstrap output -raw backend_hcl > aws/environments/dev/backend.hcl
# troque <env> por dev no backend.hcl e descomente o bloco em aws/environments/dev/backend.tf
make init                                        # detecta backend.hcl automaticamente
```

## 🔒 Segurança aplicada

| Controle | Onde |
|---|---|
| SSH restrito a CIDRs informados; `0.0.0.0/0` bloqueado por validação | `environments/dev/variables.tf` |
| IMDSv2 obrigatório (mitiga SSRF → roubo de credenciais) | `modules/ec2-instance` |
| Volume raiz gp3 criptografado | `modules/ec2-instance` |
| Bucket de state: versionamento, SSE-KMS, bloqueio público, TLS obrigatório, `prevent_destroy` | `bootstrap/` |
| Tags padrão (`Project`, `Environment`, `Owner`, `ManagedBy`) via `default_tags` | `environments/dev/providers.tf` |
| `.tfvars`, `.tfstate`, `.pem` fora do git; hooks detectam chaves privadas/credenciais | `.gitignore`, `.pre-commit-config.yaml` |

## 🧪 Qualidade

```bash
make check         # fmt-check + validate + lint
pre-commit install # roda fmt/validate/tflint a cada commit
```
