include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules//tf_state_s3"
}
