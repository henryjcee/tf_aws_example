variable "name" {
  type = string
}

resource "aws_iam_user" "user" {
  name = var.name
}

resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.user.name
}

output "arn" {
  value = aws_iam_user.user.arn
}

output "username" {
  value = aws_iam_user.user.name
}

output "secret_key" {
  value = aws_iam_access_key.access_key.secret
  sensitive = true
}
