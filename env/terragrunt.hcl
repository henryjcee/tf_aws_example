# Load env vars...
locals {
  env_vars = yamldecode(file(find_in_parent_folders("env.yaml")))
}

# ...and make them available as inputs
inputs = {
  region = "<YOUR_HOME_REGION>"
  aws_root_account_id = "<YOUR_AWS_ROOT_ACCOUNT_ID>"
  env = local.env_vars.env
  aws_account_id = local.env_vars.aws_account_id
}

# Comment this for initial setup
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "<YOUR_HOME_REGION>"
  profile = "${local.env_vars.env == "root" ? "default" : local.env_vars.env}"
}

provider "aws" {
  alias = "useast"
  region = "us-east-1"
  profile = "${local.env_vars.env == "root" ? "default" : local.env_vars.env}"
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.63.0"
    }
    acme = {
      source = "vancluever/acme"
      version = "2.6.0"
    }
  }
}
EOF
}

# Uncomment this after initial setup
#remote_state {
#  backend = "s3"
#  config = {
#    bucket         = "<YOUR_STATE_BUCKET_NAME>"
#    key            = "${path_relative_to_include()}/terraform.tfstate"
#    region         = "<YOUR_HOME_REGION>"
#    encrypt        = true
#  }
#}
