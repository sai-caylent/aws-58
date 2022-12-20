variable "cache_policy_name" {
  default = "Managed-CachingDisabled"
}
data "aws_cloudfront_cache_policy" "cache_policy" {
  name = var.cache_policy_name
}
resource "aws_cloudfront_distribution" "s3_distribution" {

origin {
    domain_name = "test.sai.cloudns.ph.s3-website.us-east-2.amazonaws.com"
    origin_id   = aws_s3_bucket.comain.bucket_regional_domain_name
    custom_origin_config {
      http_port = "80"
      https_port = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
    
}
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "this is for testing"
  aliases = ["test.sai.cloudns.ph"]


default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.comain.bucket_regional_domain_name
    cache_policy_id = data.aws_cloudfront_cache_policy.cache_policy.id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress             = true
  }

price_class = "PriceClass_200"
restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "IN"]
    }
  }

viewer_certificate {
    # cloudfront_default_certificate = false
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
    acm_certificate_arn = aws_acm_certificate.cert.arn
  }
  }