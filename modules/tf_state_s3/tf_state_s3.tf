# Comment for initial setup
terraform {
  backend "s3" {}
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "example-tfstate"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {

  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}
