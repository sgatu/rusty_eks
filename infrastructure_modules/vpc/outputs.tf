output "vpc_id" {
  value = module.vpc.vpc_id
}
output "private_subnet_ids" {
  value = module.vpc.private_subnets
}
output "public_subnet_ids" {
  value = module.vpc.public_subnets
}
output "database_subnet_ids" {
  value = module.vpc.database_subnets
}
output "azs" {
  value = module.vpc.azs
}
output "public_sg_id" {
  value = module.public_sg.security_group_id
}
output "private_sg_id" {
  value = module.private_sg.security_group_id
}
output "database_sg_id" {
  value = module.database_sg.security_group_id
}
output "bastion_sg_id" {
  value = length(module.bastion_sg) > 0 ? module.bastion_sg[0].security_group_id : null
}
output "database_subnet_group_name" {
  value = module.vpc.database_subnet_group_name
}
