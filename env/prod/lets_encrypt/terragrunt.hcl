include {
  path = find_in_parent_folders("base.hcl")
}

include "lets_encrypt" {
  path = "${get_terragrunt_dir()}/../../_common/lets_encrypt.hcl"
}
