include {
  path = find_in_parent_folders("base.hcl")
}

include "route53" {
  path = "${get_terragrunt_dir()}/../../_common/route53.hcl"
}

dependency "dev_route53_zone" {
  config_path = "../../dev/route53_zone"
}

inputs = {
  example_com_subdomain_nameservers = [
    { subdomain: "dev.example.com", nameservers: dependency.dev_route53_zone.outputs.example_com_zone_info.nameservers }
  ]
}
