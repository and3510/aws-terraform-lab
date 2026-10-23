locals {
  name = "${var.project}-${var.environment}"
}

module "ssh_sg" {
  source = "../../modules/security-group"

  name        = "${local.name}-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress_rules = [{
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }]
}

module "server" {
  source = "../../modules/ec2-instance"

  name               = "${local.name}-server"
  instance_type      = var.instance_type
  key_name           = var.key_name
  subnet_id          = var.subnet_id
  security_group_ids = [module.ssh_sg.id]
}
