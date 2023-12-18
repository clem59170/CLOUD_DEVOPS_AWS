resource "aws_s3_bucket" "cyclone_web_bucket" {
  bucket = "s3-cyclone-web-front"




  tags = {
    Name        = "s3-cyclone-web-front"
    Environment = "prod"
    Group       = "cyclone"
  }
}
resource "aws_s3_bucket_cors_configuration" "cors" {
  bucket = aws_s3_bucket.cyclone_web_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = ["https://d1mhyz71pk3h10.cloudfront.net"]
    expose_headers  = ["Authorization", "Content-Length", "ETag", "Content-Type", "x-amz-request-id", "x-amz-id-2"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_public_access_block" "cyclone_web_bucket_access_block" {
  bucket = aws_s3_bucket.cyclone_web_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}



resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.cyclone_web_bucket.id

  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::s3-cyclone-web-front/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::144312316210:distribution/E2V01OEW426WWK"
          }
        }
      }
    ]
  })
}


resource "aws_s3_object" "web_content" {
  for_each = fileset("${path.module}/website", "**/*")
  bucket   = aws_s3_bucket.cyclone_web_bucket.bucket
  key      = each.value
  source   = "${path.module}/website/${each.value}"
  etag     = filemd5("${path.module}/website/${each.value}")
  # Mise à jour pour définir le type MIME pour les fichiers .js
  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "png"  = "image/png",
    "xml"  = "application/xml"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "binary/octet-stream")

  tags = {
    Name        = "s3-cyclone-object"
    Environment = "prod"
    Group       = "cyclone"
  }
}