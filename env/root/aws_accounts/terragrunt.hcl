include {
  path = find_in_parent_folders("base.hcl")
}

terraform {
  source = "../../../modules//aws_accounts"
}

dependencies {
  paths = ["../tf_state_s3"]
}
