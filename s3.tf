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
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.comain.arn,
      "${aws_s3_bucket.comain.arn}/*",
    ]
  }
  #   statement {
  #   sid    = "Access from CDN"
  #   effect = "Allow"
  #   principals {
  #     type        = "Service"
  #     identifiers = ["cloudfront.amazonaws.com", ]
  #   }
  #   actions = ["s3:GetObject", ]
  #   resources = [

  #     "${aws_s3_bucket.comain.arn}/*",
  #   ]
  #   condition {
  #     test     = "StringEquals"
  #     variable = "AWS:SourceArn"
  #     values = [
  #       # "arn:aws:cloudfront::131578276461:distribution/E20BY5DTHU1RWA",
  #         aws_cloudfront_distribution.s3_distribution.arn,
  #     ]
  #   }
  # }
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