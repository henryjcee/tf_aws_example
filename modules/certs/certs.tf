terraform {
  backend "s3" {}
}

variable "env" {
  type = string
}

variable "example_com_acme_certificate" {
  type    = object({
    private_key_pem = string
    certificate_pem = string
    issuer_pem = string
  })
}

resource "aws_acm_certificate" "example_com" {
  private_key       = var.example_com_acme_certificate.private_key_pem
  certificate_body  = var.example_com_acme_certificate.certificate_pem
  certificate_chain = "${var.example_com_acme_certificate.certificate_pem}${var.example_com_acme_certificate.issuer_pem}"
  lifecycle {
    create_before_destroy = true
  }
}

output "example_com_certificate" {
  value = {
    certificate_arn = aws_acm_certificate.example_com.arn
    certificate_chain = aws_acm_certificate.example_com.certificate_chain
  }
}
