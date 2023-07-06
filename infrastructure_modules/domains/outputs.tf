output "certificate_arns" {
  value = zipmap(keys(var.domains), [for certificate in aws_acm_certificate.this : certificate.arn])
}
