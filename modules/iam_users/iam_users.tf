terraform {
  backend "s3" {}
}

// Users
module "terraform" {
  source      = "./iam_user"
  name        = "terraform"
}

output "terraform_user_arn" {
  value = module.terraform.arn
}
