locals {
  name = "${var.project}-local"
}

module "ssh_sg" {
  source = "../../modules/security-group"

  name        = "${local.name}-ssh"
  description = "Allow SSH inbound traffic"

  ingress_rules = [{
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }]
}

module "server" {
  source = "../../modules/ec2-instance"

  name               = "${local.name}-server"
  instance_type      = var.instance_type
  ami_id             = var.ami_id
  security_group_ids = [module.ssh_sg.id]

  # LocalStack não implementa ModifyInstanceMetadataOptions
  manage_metadata_options = false
}

module "server2" {
  source = "../../modules/ec2-instance"

  name               = "${local.name}-server-2"
  instance_type      = var.instance_type
  ami_id             = var.ami_id
  security_group_ids = [module.ssh_sg.id]

  # LocalStack não implementa ModifyInstanceMetadataOptions
  manage_metadata_options = false
}
