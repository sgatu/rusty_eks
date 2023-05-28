output "cluster_name" {
  value = var.create ? module.eks[0].cluster_name : null
}
output "cluster_endpoint" {
  value = var.create ? module.eks[0].cluster_endpoint : null
}
output "cluster_ca_certificate" {
  value = var.create ? module.eks[0].cluster_certificate_authority_data : null
}
