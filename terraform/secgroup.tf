
resource "aws_security_group" "main" {
  name   = "main"
  vpc_id = aws_vpc.main.id
  tags   = var.default_tags
}

resource "aws_vpc_security_group_egress_rule" "main_allow_egress" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = var.all_cidr
  ip_protocol       = "-1"
  tags              = var.default_tags
}

resource "aws_vpc_security_group_egress_rule" "main_ipv6_allow_egress" {
  security_group_id = aws_security_group.main.id
  cidr_ipv6         = var.all_ipv6_cidr
  ip_protocol       = "-1"
  tags              = var.default_tags
}

resource "aws_vpc_security_group_ingress_rule" "main_limit_ssh_ingress" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = var.allowed_ssh_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags              = var.default_tags
}

resource "aws_vpc_security_group_ingress_rule" "main_ipv6_limit_ssh_ingress" {
  security_group_id = aws_security_group.main.id
  cidr_ipv6         = var.allowed_ipv6_ssh_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags              = var.default_tags
}

resource "aws_vpc_security_group_ingress_rule" "main_tcp_ingress_1" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = var.all_cidr
  from_port         = 1
  ip_protocol       = "tcp"
  to_port           = 21
  tags              = var.default_tags
}

resource "aws_vpc_security_group_ingress_rule" "main_ipv6_tcp_ingress_1" {
  security_group_id = aws_security_group.main.id
  cidr_ipv6         = var.all_ipv6_cidr
  from_port         = 1
  ip_protocol       = "tcp"
  to_port           = 21
  tags              = var.default_tags
}

resource "aws_vpc_security_group_ingress_rule" "main_tcp_ingress_2" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = var.all_cidr
  from_port         = 23
  ip_protocol       = "tcp"
  to_port           = 65535
  tags              = var.default_tags
}

resource "aws_vpc_security_group_ingress_rule" "main_ipv6_tcp_ingress_2" {
  security_group_id = aws_security_group.main.id
  cidr_ipv6         = var.all_ipv6_cidr
  from_port         = 23
  ip_protocol       = "tcp"
  to_port           = 65535
  tags              = var.default_tags
}

resource "aws_vpc_security_group_ingress_rule" "main_udp_ingress_1" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = var.all_cidr
  from_port         = 1
  ip_protocol       = "udp"
  to_port           = 21
  tags              = var.default_tags
}

resource "aws_vpc_security_group_ingress_rule" "main_ipv6_udp_ingress_1" {
  security_group_id = aws_security_group.main.id
  cidr_ipv6         = var.all_ipv6_cidr
  from_port         = 1
  ip_protocol       = "udp"
  to_port           = 21
  tags              = var.default_tags
}

resource "aws_vpc_security_group_ingress_rule" "main_udp_ingress_2" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = var.all_cidr
  from_port         = 23
  ip_protocol       = "udp"
  to_port           = 65535
  tags              = var.default_tags
}

resource "aws_vpc_security_group_ingress_rule" "main_ipv6_udp_ingress_2" {
  security_group_id = aws_security_group.main.id
  cidr_ipv6         = var.all_ipv6_cidr
  from_port         = 23
  ip_protocol       = "udp"
  to_port           = 65535
  tags              = var.default_tags
}
