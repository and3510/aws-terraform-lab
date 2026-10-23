resource "aws_security_group" "this" {
  name_prefix = "${var.name}-"
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = var.name })

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  # Uma regra por combinação (regra x CIDR), exigido pelos recursos aws_vpc_security_group_*_rule
  ingress = merge([
    for rule in var.ingress_rules : {
      for cidr in rule.cidr_blocks :
      "${rule.protocol}-${rule.from_port}-${rule.to_port}-${cidr}" => merge(rule, { cidr = cidr })
    }
  ]...)
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = local.ingress

  security_group_id = aws_security_group.this.id
  description       = each.value.description
  ip_protocol       = each.value.protocol
  from_port         = each.value.protocol == "-1" ? null : each.value.from_port
  to_port           = each.value.protocol == "-1" ? null : each.value.to_port
  cidr_ipv4         = each.value.cidr

  tags = var.tags
}

resource "aws_vpc_security_group_egress_rule" "all" {
  count = var.allow_all_egress ? 1 : 0

  security_group_id = aws_security_group.this.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = var.tags
}
