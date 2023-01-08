resource "aws_s3_bucket" "comain" {
  bucket = "test.sai.cloudns.ph"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.comain.id
  acl    = "private"
}
resource "aws_s3_bucket_policy" "comain" {
  bucket = aws_s3_bucket.comain.id
  policy = data.aws_iam_policy_document.comain.json
}
data "aws_iam_policy_document" "comain" {
  #policy for OAI
  statement {
    sid    = "Access from CDN"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
    actions = ["s3:GetObject", ]
    resources = [

      "${aws_s3_bucket.comain.arn}/*",
    ]
  }
  #policy for OAC

  statement {
    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.comain.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3.arn]
    }
  }
}
resource "aws_s3_bucket_website_configuration" "example2" {
  bucket = aws_s3_bucket.comain.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}