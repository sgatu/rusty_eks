data "local_file" "iam_policy" {
  filename = "${path.module}/config/dns_policy.json"
}
