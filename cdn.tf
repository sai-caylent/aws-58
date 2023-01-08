variable "cache_policy_name" {
  default = "Managed-CachingDisabled"
}
data "aws_cloudfront_cache_policy" "cache_policy" {
  name = var.cache_policy_name
}
locals {
  s3_origin_id = "test.sai.cloudns.ph"
  oai_path     = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
}
resource "aws_cloudfront_distribution" "s3" {

  origin {
    domain_name = aws_s3_bucket.comain.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = local.oai_path
    }
  }
  origin {
    domain_name              = aws_s3_bucket.comain.bucket_regional_domain_name
    origin_id                = "files_oac"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "testing for f45 project S3 bucket"
  aliases             = ["test.sai.cloudns.ph"]
  price_class         = "PriceClass_100"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "files_oac"
    cache_policy_id        = data.aws_cloudfront_cache_policy.cache_policy.id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }


  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA"]
    }
  }

  # viewer_certificate {
  #   # cloudfront_default_certificate = false
  #   ssl_support_method       = "sni-only"
  #   minimum_protocol_version = "TLSv1"
  #   acm_certificate_arn      = aws_acm_certificate.cert.arn
  # }
   viewer_certificate {
    cloudfront_default_certificate = true
  }

}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "test-sai"
  description                       = "testing for f45 project S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "test.sai.cloudns.ph"
}
output "cf_domain_name" {
  value = aws_cloudfront_distribution.s3.domain_name

}
output "oai_arn" {
  value = aws_cloudfront_origin_access_identity.oai.iam_arn

}