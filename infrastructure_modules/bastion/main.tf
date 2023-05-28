data "aws_ami" "bastion_ami" {
  most_recent = true
  name_regex  = ".*ubuntu-jammy-22.04-arm64.*"
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  owners = ["099720109477"]
}
resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion_key"
  public_key = tls_private_key.bastion_key.public_key_openssh
  provisioner "local-exec" {
    command = "echo '${tls_private_key.bastion_key.private_key_pem}' > ${var.output_private_key_path} && chmod 400 ${var.output_private_key_path}"
  }
}
module "bastion_instance" {
  source = "../../resource_modules/ec2/instance"

  security_group_ids          = [var.security_group_id]
  subnet_id                   = var.subnet_id
  availability_zone           = var.availability_zone
  ami                         = data.aws_ami.bastion_ami.id
  instance_type               = local.instance_type
  key_name                    = aws_key_pair.bastion_key.key_name
  tags                        = var.tags
  associate_public_ip_address = true
  spot_instance               = var.is_spot ? local.spot_config : null
}

resource "null_resource" "delete_private_key" {
  count = var.delete_private_key_on_destroy ? 1 : 0
  triggers = {
    path                          = var.output_private_key_path
    delete_private_key_on_destroy = var.delete_private_key_on_destroy
  }
  provisioner "local-exec" {
    command    = self.triggers.delete_private_key_on_destroy ? "chmod 700 ${self.triggers.path} && rm -f ${self.triggers.path}" : "/bin/true"
    when       = destroy
    on_failure = continue
  }
}
