data "aws_ami" "demo_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = var.name_filter
  }

  filter {
    name   = "virtualization-type"
    values = var.virtualization_type_filter
  }

  owners = var.owner
}