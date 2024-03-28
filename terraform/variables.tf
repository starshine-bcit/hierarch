variable "base_cidr" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "region" {
  type = string
}

variable "az" {
  type = string
}

variable "all_cidr" {
  type = string
}

variable "all_ipv6_cidr" {
  type = string
}

variable "allowed_ssh_cidr" {
  type = string
}

variable "allowed_ipv6_ssh_cidr" {
  type = string
}

variable "default_tags" {
  type = object({
    Name = string
  })
}

variable "admin_tags" {
  type = object({
    Name = string
    Type = string
  })
}

variable "mail_tags" {
  type = object({
    Name = string
    Type = string
  })
}

variable "app_tags" {
  type = object({
    Name = string
    Type = string
  })
}
