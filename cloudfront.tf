resource "aws_s3_bucket" "app_website_bucket" {
  bucket = "app-public-static-website-bucket"
}

resource "aws_s3_bucket_ownership_controls" "public" {
  bucket = aws_s3_bucket.app_website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public" {
  bucket = aws_s3_bucket.app_website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "public" {
  depends_on = [
    aws_s3_bucket_ownership_controls.public,
    aws_s3_bucket_public_access_block.public,
  ]

  bucket = aws_s3_bucket.app_website_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "configurations" {
  bucket = aws_s3_bucket.app_website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

locals {
  s3_origin_id = "appS3Origin"
}

resource "aws_cloudfront_distribution" "website_distribution" {

  origin {
    domain_name = aws_s3_bucket.app_website_bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id = local.s3_origin_id

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    ssl_support_method             = "sni-only"
    acm_certificate_arn            = data.aws_acm_certificate.getthedeck.arn
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
