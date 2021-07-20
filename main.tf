provider "aws" {
  alias   = "source"
  profile = "source"
  region  = "us-east-2"
}

provider "aws" {
  alias   = "destination"
  profile = "destination"
  region  = "us-east-2"
}


data "aws_caller_identity" "source" {
  provider = aws.source
}

data "aws_iam_policy_document" "ec2_all" {
  provider = aws.destination
  statement {
    actions   = ["ec2:*"]
    resources = ["arn:aws:ec2:::*"]
  }
}

resource "aws_iam_policy" "ec2_all" {
  provider = aws.destination
  name     = "ec2_all"
  policy   = data.aws_iam_policy_document.ec2_all.json
}

data "aws_iam_policy_document" "assume_role" {
  provider = aws.destination
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.source.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "assume_role" {
  provider            = aws.destination
  name                = "assume_role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [aws_iam_policy.ec2_all.arn]
}

