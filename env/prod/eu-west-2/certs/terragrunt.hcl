include {
  path = find_in_parent_folders("base.hcl")
}

include "certs" {
  path = "${get_terragrunt_dir()}/../../../_common/certs.hcl"
}
