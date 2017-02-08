# Create the private key for the registration (not the certificate)
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

# Set up a registration using a private key from tls_private_key
resource "acme_registration" "reg" {
  server_url      = "https://acme-staging.api.letsencrypt.org/directory"
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "simon@mccartney.ie"
}

# Create a certificate
resource "acme_certificate" "certificate" {
  server_url                = "https://acme-staging.api.letsencrypt.org/directory"
  account_key_pem           = "${tls_private_key.private_key.private_key_pem}"
  common_name               = "${var.site_fqdn}"

  dns_challenge {
    provider = "route53"
  }

  registration_url = "${acme_registration.reg.id}"
}

resource "aws_iam_server_certificate" "redirect_cert" {
  certificate_body = "${acme_certificate.certificate.certificate_pem}"
  private_key = "${acme_certificate.certificate.private_key_pem}"
  certificate_chain = "${acme_certificate.certificate.issuer_pem}"
}
