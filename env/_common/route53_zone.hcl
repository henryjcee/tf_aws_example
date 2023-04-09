terraform {
  source = "../../../modules//route53_zone"
}

dependencies {
  paths = ["../../root/aws_accounts"]
}
