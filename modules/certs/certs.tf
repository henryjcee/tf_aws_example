terraform {
  backend "s3" {}
}

variable "env" {
  type = string
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  provider = acme
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "<YOUR_EMAIL_ADDRESS>"
}

resource "acme_certificate" "your_domain" {
  provider                  = acme
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = "${var.env == "prod" ? "" : "${var.env}."}<YOUR_DOMAIN>.com"
  subject_alternative_names = ["*.${var.env == "prod" ? "" : "${var.env}."}<YOUR_DOMAIN>.com"]
  min_days_remaining = 15
  dns_challenge {
    provider = "route53"
    config = {
      AWS_SDK_LOAD_CONFIG = "true"
      AWS_PROFILE = var.env
    }
  }
}

resource "aws_acm_certificate" "your_domain" {
  private_key = acme_certificate.your_domain.private_key_pem
  certificate_body = acme_certificate.your_domain.certificate_pem
  certificate_chain = "${acme_certificate.your_domain.certificate_pem}${acme_certificate.your_domain.issuer_pem}"
  lifecycle {
    create_before_destroy = true
  }
}

output "your_domain_certificate_arn" {
  value = aws_acm_certificate.your_domain.arn
}

resource "aws_acm_certificate" "your_domain_useast1" {
  provider = aws.useast
  private_key = acme_certificate.your_domain.private_key_pem
  certificate_body = acme_certificate.your_domain.certificate_pem
  certificate_chain = "${acme_certificate.your_domain.certificate_pem}${acme_certificate.your_domain.issuer_pem}"
  lifecycle {
    create_before_destroy = true
  }
}

output "your_domain_useast1_certificate_arn" {
  value = aws_acm_certificate.your_domain_useast1.arn
}
