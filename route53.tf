resource "aws_route53_zone" "test" {
  name = "test.sai.cloudns.ph"

  tags = {
    owner = "sai",
    project = "F45"
  }
} 
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.test.zone_id
  name    = aws_route53_zone.test.name
  type    = "A"

  # alias {
  #   name                   = "s3-website.us-east-2.amazonaws.com"
  #   zone_id                = "Z2O1EMRO9K5GLX"
  #   evaluate_target_health = false
  # }
    alias {
    name                   = aws_cloudfront_distribution.s3.domain_name
    zone_id                = aws_cloudfront_distribution.s3.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true
  name =  tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
  type = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.test.zone_id
  ttl = 60
}