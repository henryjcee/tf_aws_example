include {
  path = find_in_parent_folders("base.hcl")
}

terraform {
  source = "../../../../modules//iam_users"
}

dependencies {
  paths = ["../../tf_state_s3"]
}
