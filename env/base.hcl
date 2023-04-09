# Load env vars...
locals {
  env_vars = yamldecode(join("\n", [file(find_in_parent_folders("env.yaml")), fileexists("${get_terragrunt_dir()}/../region.yaml") ? file("${get_terragrunt_dir()}/../region.yaml"): ""]))
  aws_root_account_id = "927269041804"
}

# ...and make them available as inputs
inputs = {
  region = try(local.env_vars.region, "eu-west-2") # Default to eu-west-2
  env = local.env_vars.env
  aws_account_id = local.env_vars.aws_account_id
  aws_root_account_id = local.aws_root_account_id
}

# Comment this for initial setup
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "${try(local.env_vars.region, "eu-west-2")}"
  profile = "${local.env_vars.env}"
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.61.0"
    }
    acme = {
      source = "vancluever/acme"
      version = "2.13.1"
    }
  }
}
EOF
}

# Comment for initial setup
remote_state {
  backend = "s3"
  config = {
    bucket         = "example-tfstate"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    profile        = "root"
    region         = "eu-west-2"
    encrypt        = true
  }
}
