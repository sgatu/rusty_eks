output "cluster_name" {
  value = var.create ? module.eks[0].cluster_name : null
}
output "cluster_endpoint" {
  value = var.create ? module.eks[0].cluster_endpoint : null
}
output "cluster_ca_certificate" {
  value = var.create ? module.eks[0].cluster_certificate_authority_data : null
}
output "ecr_repository_arn" {
  value = var.create ? module.ecr[0].repository_arn : null
}
output "ecr_repository_registry_id" {
  value = var.create ? module.ecr[0].repository_registry_id : null
}
output "ecr_repository_url" {
  value = var.create ? module.ecr[0].repository_url : null
}
