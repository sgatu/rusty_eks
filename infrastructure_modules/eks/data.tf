data "local_file" "elb_policy" {
  filename = "${path.module}/config/elb_policy.json"
}
data "local_file" "csi_policy" {
  filename = "${path.module}/config/csi_policy.json"
}
