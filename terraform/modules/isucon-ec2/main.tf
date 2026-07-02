locals {
  name_prefix = var.project_name
}

resource "aws_security_group" "isucon" {
  name        = "${local.name_prefix}-sg"
  description = "ISUCON14 + Splunk O11y lab instances"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.isucon.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  description       = "ISURIDE HTTPS (bench / browser)"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  for_each = toset(var.ssh_allowed_cidrs)

  security_group_id = aws_security_group.isucon.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = each.value
  description       = "SSH from allowed CIDR"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.isucon.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Egress all (Splunk O11y ingest, package updates)"
}

resource "aws_instance" "isucon" {
  for_each = var.instances

  ami                    = var.ami_id
  instance_type          = each.value.instance_type
  subnet_id              = var.public_subnet_ids[each.value.subnet_index]
  vpc_security_group_ids = [aws_security_group.isucon.id]
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile
  associate_public_ip_address = true

  user_data = var.bootstrap_user_data

  root_block_device {
    volume_size = var.root_volume_size_gb
    volume_type = "gp3"
    encrypted   = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = merge(var.tags, {
    Name = each.key
    Role = each.value.role
  })
}
