data "local_file" "iampolicy" {
  filename = "${path.module}/config/iampolicy.json"
}
locals {
  repository_name = var.repository_name == null ? "${var.cluster_name}-repo" : var.repository_name
}
