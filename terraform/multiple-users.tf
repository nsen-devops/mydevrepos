provider "aws" {
  access_key = "add your account access key"
  secret_key = "add your account secret key"
  region     = "us-east-1"
}

resource "aws_iam_user" "user1" {
  name = "user1"

  tags = {
    tag-key = "first-user"
  }
}

resource "aws_iam_user" "user2" {
  name = "user2"

  tags = {
    tag-key = "second-user"
  }
}

resource "aws_iam_user" "user3" {
  name = "user3"

  tags = {
    tag-key = "third-user"
  }
}

##############################################################################

resource "aws_iam_group" "terraform-users-group" {
  name = "terraform-users-group"
}

resource "aws_iam_group_membership" "tf-team" {
  name = "tf-users-group-membership"

  users = [
    aws_iam_user.user1.name,
    aws_iam_user.user2.name,
    aws_iam_user.user3.name,
  ]

  group = aws_iam_group.terraform-users-group.name
}
##############################################################################

resource "aws_iam_policy" "s3-full-access" {
  name = "s3-full-access"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "iam-policy-tf" {
  group      = aws_iam_group.terraform-users-group.name
  policy_arn = aws_iam_policy.s3-full-access.arn
}
