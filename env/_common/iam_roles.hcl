terraform {
  source = "../../../../modules//iam_roles"
}

dependencies {
  paths = ["../../../root/aws_accounts"]
}

dependency "iam_users" {
  config_path = "../../../root/eu-west-2/iam_users"
}

inputs = {
  terraform_user_arn = dependency.iam_users.outputs.terraform_user_arn
}
