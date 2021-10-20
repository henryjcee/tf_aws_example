terraform {
  backend "s3" {}
}

variable "env" {
  type = string
}

variable "henrycourse_subdomain_nameservers" {
  type = list(object({subdomain=string, nameservers=set(string)}))
  default = []
}

locals {
  henrycourse_domain_name = "${var.env == "prod" ? "" : "${var.env}."}henrycourse.com"
}

module "henrycourse" {
  source         = "./zone"
  domain         = local.henrycourse_domain_name
  subdomain_nameservers = var.henrycourse_subdomain_nameservers
}

output "henrycourse_zone_info" {
  value = {
    subdomain = var.env == "prod" ? "" : var.env
    zone_id = module.henrycourse.zone_id
    nameservers = module.henrycourse.nameservers
  }
}

resource "aws_route53_record" "henrycourse_root" {
  zone_id = module.henrycourse.zone_info.zone_id
  name    = local.henrycourse_domain_name
  type    = "A"
  records = ["<IP_ADDRESS_HERE>"]
}
