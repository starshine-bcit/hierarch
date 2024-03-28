
resource "aws_vpc" "main" {
  cidr_block                       = var.base_cidr
  instance_tenancy                 = "default"
  enable_dns_hostnames             = false
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = true
  tags                             = var.default_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = var.default_tags
}

resource "aws_subnet" "main" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = var.subnet_cidr
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 1)
  assign_ipv6_address_on_creation = true
  availability_zone               = var.az
  map_public_ip_on_launch         = true
  tags                            = var.default_tags
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id
  tags                   = var.default_tags
  route {
    cidr_block = var.all_cidr
    gateway_id = aws_internet_gateway.main.id
  }
  route {
    ipv6_cidr_block = var.all_ipv6_cidr
    gateway_id      = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_default_route_table.main.id
}

