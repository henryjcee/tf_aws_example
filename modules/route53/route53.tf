terraform {
  backend "s3" {}
}

variable "env" {
  type = string
}

variable "subdomain_nameservers" {
  type = list(object({subdomain=string, nameservers=set(string)}))
  default = []
}

locals {
  example_domain_name = "${var.env == "prod" ? "" : "${var.env}."}example.com"
}

module "example" {
  source         = "./zone"
  domain         = local.example_domain_name
  subdomain_nameservers = var.subdomain_nameservers
}

output "example_com_zone_info" {
  value = {
    subdomain = var.env == "prod" ? "" : var.env
    zone_id = module.example.zone_id
    nameservers = module.example.nameservers
  }
}

resource "aws_route53_record" "example_root" {
  zone_id = module.example.zone_info.zone_id
  name    = local.example_domain_name
  type    = "A"
  records = ["<IP_ADDRESS_HERE>"]
}
