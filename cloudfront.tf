resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    # domain_name = "${aws_s3_bucket.redirect_test.website_endpoint}"
    # redirect.halftown.co.uk.s3.amazonaws.com
    domain_name = "${aws_s3_bucket.redirect_test.bucket}.s3.amazonaws.com"
    origin_id   = "${var.site_fqdn}-origin"
  }

  enabled             = true
  comment             = "Some comment"
  default_root_object = "index.html"

  aliases = ["${var.site_fqdn}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.site_fqdn}-origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # US & Europe only
  price_class = "PriceClass_100"

  # https config
  viewer_certificate {
    iam_certificate_id = "${aws_iam_server_certificate.redirect_cert.arn}"
    minimum_protocol_version = "TLSv1"
    ssl_support_method = "sni-only"
  }
}
