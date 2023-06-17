include {
  path = find_in_parent_folders("base.hcl")
}

include "route53" {
  path = "${get_terragrunt_dir()}/../../_common/route53.hcl"
}
