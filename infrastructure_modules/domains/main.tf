resource "aws_acm_certificate" "this" {
  for_each          = var.domains
  domain_name       = format("*.%s", each.key)
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_route53_record" "dns_validation_record" {
  for_each        = aws_acm_certificate.this
  allow_overwrite = true
  name            = tolist(each.value.domain_validation_options)[0].resource_record_name
  records         = [tolist(each.value.domain_validation_options)[0].resource_record_value]
  type            = tolist(each.value.domain_validation_options)[0].resource_record_type
  zone_id         = var.domains[each.key]
  ttl             = 60
}
resource "aws_acm_certificate_validation" "this" {
  for_each                = aws_acm_certificate.this
  certificate_arn         = each.value.arn
  validation_record_fqdns = [aws_route53_record.dns_validation_record[each.key].fqdn]
}

