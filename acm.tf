resource "aws_acm_certificate" "cert" {
  provider = aws.alternate_region
  domain_name       = "test.sai.cloudns.ph"
  validation_method = "DNS"

  tags = {
    Owner = "Sai"
  }

  lifecycle {
    create_before_destroy = true
  }
}