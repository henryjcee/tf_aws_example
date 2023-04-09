include {
  path = find_in_parent_folders("base.hcl")
}

include "route53_zone" {
  path = "${get_terragrunt_dir()}/../../_common/route53_zone.hcl"
}
