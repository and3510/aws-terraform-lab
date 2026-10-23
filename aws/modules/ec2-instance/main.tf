# AMI Ubuntu LTS mais recente da Canonical, usada quando var.ami_id não é informado
data "aws_ami" "ubuntu" {
  count = var.ami_id == null ? 1 : 0

  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-${var.ubuntu_release}-${var.architecture}-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "this" {
  ami                         = coalesce(var.ami_id, try(data.aws_ami.ubuntu[0].id, null))
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  monitoring                  = var.detailed_monitoring
  user_data                   = var.user_data
  user_data_replace_on_change = true

  # IMDSv2 obrigatório (mitiga SSRF -> roubo de credenciais)
  dynamic "metadata_options" {
    for_each = var.manage_metadata_options ? [1] : []

    content {
      http_endpoint               = "enabled"
      http_tokens                 = "required"
      http_put_response_hop_limit = 1
    }
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true
  }

  tags        = merge(var.tags, { Name = var.name })
  volume_tags = merge(var.tags, { Name = var.name })

  lifecycle {
    # Evita recriar a instância sempre que a Canonical publicar uma AMI nova
    ignore_changes = [ami]
  }
}
