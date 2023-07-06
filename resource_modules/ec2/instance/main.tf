resource "aws_instance" "this" {
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id
  availability_zone      = var.availability_zone
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  dynamic "launch_template" {
    for_each = var.launch_template[*]
    content {
      id      = launch_template.value.id
      name    = launch_template.value.name
      version = launch_template.value.version
    }
  }
  tags                        = var.tags
  associate_public_ip_address = var.associate_public_ip_address
  count                       = var.spot_instance == null ? 1 : 0
}
resource "aws_spot_instance_request" "this" {
  ami                    = var.ami
  spot_price             = var.spot_instance.spot_price
  instance_type          = var.instance_type
  block_duration_minutes = var.spot_instance.block_duration_minutes
  wait_for_fulfillment   = var.spot_instance.wait_for_fulfillment
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id
  dynamic "launch_template" {
    for_each = var.launch_template[*]
    content {
      id      = launch_template.value.id
      name    = launch_template.value.name
      version = launch_template.value.version
    }
  }
  tags                        = var.tags
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name
  count                       = var.spot_instance == null ? 0 : 1
}
