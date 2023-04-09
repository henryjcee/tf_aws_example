terraform {
  source = "../../../modules//lets_encrypt"
}

dependencies {
  paths = ["../route53_zone"]
}
