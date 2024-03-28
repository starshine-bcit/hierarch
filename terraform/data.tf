
resource "aws_key_pair" "local_key" {
  key_name   = "aws02"
  public_key = file(pathexpand("~/.ssh/aws02.pub"))
  tags       = var.default_tags
}
