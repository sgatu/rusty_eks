data "local_file" "elb_policy" {
  filename = "${path.module}/config/elb_policy.json"
}
data "local_file" "csi_policy" {
  filename = "${path.module}/config/csi_policy.json"
}
locals {
  repository_name = var.repository_name == null ? "${var.cluster_name}-repo" : var.repository_name
}
