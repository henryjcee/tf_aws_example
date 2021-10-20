# Uncomment this after initial setup
#terraform {
#  backend "s3" {}
#}

resource "aws_s3_bucket" "tf_state" {
  bucket = "tf-state-<RANDOM_STRING>"
  acl    = "private"
  versioning {
    enabled = true
  }
}
