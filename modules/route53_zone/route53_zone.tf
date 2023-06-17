terraform {
  backend "s3" {}
}

variable "env" {
  type = string
}

variable "example_com_subdomain_nameservers" {
  type    = list(object({ subdomain = string, nameservers = set(string) }))
  default = []
}

locals {
  example_com_domain = "${var.env == "prod" ? "" : "${var.env}."}example.com"
}

module "example_com" {
  source                = "./zone"
  domain                = local.example_com_domain
  subdomain_nameservers = var.example_com_subdomain_nameservers
}

output "example_com_zone_info" {
  value = {
    subdomain   = var.env == "prod" ? "" : var.env
    zone_id     = module.example_com.zone_info.zone_id
    nameservers = module.example_com.zone_info.nameservers
  }
}
