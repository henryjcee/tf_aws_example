terraform {
  backend "s3" {}
}

variable "env" {
  type = string
}

variable "example_com_zone_id" {
  type = string
}

locals {
  example_com_domain = "${var.env == "prod" ? "" : "${var.env}."}example.com"
}

resource "aws_route53_record" "example_root" {
  zone_id = var.example_com_zone_id
  name    = local.example_com_domain
  type    = "A"
  records = ["<IP_ADDRESS>"]
}
