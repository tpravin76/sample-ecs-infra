#creating OAI :
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.domain_name}"
}
# cloudfront terraform - creating AWS Cloudfront distribution :
resource "aws_cloudfront_distribution" "cf_dist" {
  enabled             = true
  aliases             = [var.domain_name]
  default_root_object = "index.html"
  origin {
    domain_name = var.aws_s3_bucket_domain_name
    origin_id   = var.s3_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = var.s3_id
    viewer_protocol_policy = "redirect-to-https" # other options - https only, http
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers_policy.id
    forwarded_values {
      headers      = []
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  tags = {
    Name        = var.app_name
    Environment = var.app_environment
  }
}

resource "aws_cloudfront_response_headers_policy" "security_headers_policy" {
  name = "cloudfront-security-headers-policy"
  security_headers_config {
    content_type_options {
      override = true
    }
    frame_options {
      frame_option = "DENY"
      override = true
    }
    referrer_policy {
      referrer_policy = "same-origin"
      override = true
    }
    xss_protection {
      mode_block = true
      protection = true
      override = true
    }
    strict_transport_security {
      access_control_max_age_sec = "63072000"
      include_subdomains = true
      preload = true
      override = true
    }
    content_security_policy {
      content_security_policy = "default-src 'self'; script-src 'self' 'unsafe-eval'; style-src-attr 'unsafe-inline'; connect-src *.llsapi.com *.incontact.com *.niceincontact.com wss://*.niceincontact.com; img-src 'self' *.llsapi.com"
      override = true
    }
  }
}

# add bucket policy to let the CloudFront OAI get objects:
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.s3_id
  policy = data.aws_iam_policy_document.bucket_policy_document.json
}

