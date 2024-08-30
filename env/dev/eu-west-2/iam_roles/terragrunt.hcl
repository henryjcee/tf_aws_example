include {
  path = find_in_parent_folders("base.hcl")
}

terraform {
  source = "../../../modules//iam_roles"
}

dependency "iam_users" {
  config_path = "../../root/iam_users"
}

inputs = {
  terraform_user_arn = dependency.iam_users.outputs.terraform_user_arn
}
