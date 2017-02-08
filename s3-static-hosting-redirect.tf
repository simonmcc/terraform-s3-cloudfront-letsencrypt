
resource "aws_s3_bucket" "redirect_test" {
    bucket = "${var.bucket_name}"
    acl = "public-read"
    policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"PublicReadForGetBucketObjects",
      "Effect":"Allow",
      "Principal": "*",
      "Action":"s3:GetObject",
      "Resource":"arn:aws:s3:::${var.bucket_name}/*"
  }]
}
POLICY

    website {
        redirect_all_requests_to = "${var.redirect_to}"
    }
}

resource "aws_route53_record" "redirect" {
  zone_id = "${var.site_hostedzone}"
  name = "${var.site_fqdn}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_s3_bucket.redirect_test.website_endpoint}"]
}
