

resource "aws_instance" "admin" {
  instance_type          = "t3a.large"
  ami                    = data.aws_ami.debian.id
  key_name               = aws_key_pair.local_key.key_name
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id              = aws_subnet.main.id
  tags                   = var.admin_tags
  ipv6_addresses         = [cidrhost(aws_subnet.main.ipv6_cidr_block, 128)]
  root_block_device {
    volume_size = 240
  }
}

resource "aws_instance" "mail" {
  instance_type          = "t3a.large"
  ami                    = data.aws_ami.debian.id
  key_name               = aws_key_pair.local_key.key_name
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id              = aws_subnet.main.id
  tags                   = var.mail_tags
  ipv6_addresses         = [cidrhost(aws_subnet.main.ipv6_cidr_block, 256)]
  root_block_device {
    volume_size = 80
  }
}

resource "aws_instance" "app" {
  instance_type          = "t3a.xlarge"
  ami                    = data.aws_ami.debian.id
  key_name               = aws_key_pair.local_key.key_name
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id              = aws_subnet.main.id
  tags                   = var.app_tags
  ipv6_addresses         = [cidrhost(aws_subnet.main.ipv6_cidr_block, 512)]
  root_block_device {
    volume_size = 160
  }
}

resource "aws_eip" "admin_ip" {
  instance   = aws_instance.admin.id
  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]
  tags       = var.default_tags
}

resource "aws_eip" "mail_ip" {
  instance   = aws_instance.mail.id
  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]
  tags       = var.default_tags
}

resource "aws_eip" "app_ip" {
  instance   = aws_instance.app.id
  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]
  tags       = var.default_tags
}


