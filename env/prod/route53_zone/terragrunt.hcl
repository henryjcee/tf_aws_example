include {
  path = find_in_parent_folders("base.hcl")
}

include "route53_zone" {
  path = "${get_terragrunt_dir()}/../../_common/route53_zone.hcl"
}

dependency "dev_route53_zone" {
  config_path = "../../dev/route53_zone"
}

inputs = {
  example_com_subdomain_nameservers = [dependency.dev_route53_zone.outputs.example_com_zone_info]
}
