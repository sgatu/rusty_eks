output "output_private_key_path" {
  value = var.output_private_key_path
}
output "private_ip" {
    value = module.bastion_instance.private_ip
}
output "public_ip" {
    value = module.bastion_instance.public_ip
}