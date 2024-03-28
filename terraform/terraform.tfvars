base_cidr             = "172.16.0.0/23"
subnet_cidr           = "172.16.0.0/25"
region                = "us-west-2"
az                    = "us-west-2a"
all_cidr              = "0.0.0.0/0"
all_ipv6_cidr         = "::/0"
allowed_ssh_cidr      = "142.232.0.0/16"
allowed_ipv6_ssh_cidr = "2a02:6ea0:2800::/40"
default_tags = {
  Name = "hierarch"
}
admin_tags = {
  Name = "hierarch"
  Type = "admin"
}
mail_tags = {
  Name = "hierarch"
  Type = "mail"
}
app_tags = {
  Name = "hierarch"
  Type = "app"
}
