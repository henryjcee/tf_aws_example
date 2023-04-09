terraform {
  backend "s3" {}
}

variable "env" {
  type = string
}

variable "account_key_pem" {
  type = string
  default = ""
}

resource "acme_registration" "example_com" {
  provider        = acme
  account_key_pem = var.account_key_pem
  email_address   = "robots${var.env == "prod" ? "" : "+${var.env}"}@example.com"
  lifecycle {
    ignore_changes = [account_key_pem]
  }
}

resource "acme_certificate" "example_com" {
  key_type                  = "P256"
  provider                  = acme
  account_key_pem           = acme_registration.example_com.account_key_pem
  common_name               = "${var.env == "prod" ? "" : "${var.env}."}example.com"
  subject_alternative_names = ["*.${var.env == "prod" ? "" : "${var.env}."}example.com"]
  min_days_remaining        = 30
  dns_challenge {
    provider = "route53"
    config   = {
      AWS_SDK_LOAD_CONFIG = "true"
      AWS_PROFILE         = var.env
    }
  }
}

output "example_com_acme_certificate" {
  value     = acme_certificate.example_com
  sensitive = true
}
