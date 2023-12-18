resource "aws_cloudfront_distribution" "cyclone_cloudfront_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution for Cyclone Web Front"
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  origin {
    domain_name              = aws_s3_bucket.cyclone_web_bucket.bucket_regional_domain_name
    origin_id                = "s3-cyclone-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.cyclone_cloudfront_oac.id

  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "DELETE", "PATCH", "PUT", "POST"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-cyclone-origin"

    forwarded_values {
      query_string = false
      headers      = ["Origin", "Access-Control-Request-Method","Access-Control-Request-Headers", "Content-Type"]
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    viewer_protocol_policy = "redirect-to-https"
  }

  tags = {
    Name        = "cyclone-cloudfront"
    Environment = "prod"
    Group       = "cyclone"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_control" "cyclone_cloudfront_oac" {
  name                              = aws_s3_bucket.cyclone_web_bucket.bucket_regional_domain_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
