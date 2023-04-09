terraform {
  backend "s3" {}
}

resource "aws_organizations_account" "prod" {

  name = "prod"
  email = "prod@example.com"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_organizations_account" "dev" {

  name = "dev"
  email = "dev@example.com"

  lifecycle {
    prevent_destroy = true
  }
}

output "aws_account_ids" {
  value = {
    prod = aws_organizations_account.prod.id
    dev = aws_organizations_account.dev.id
  }
}
