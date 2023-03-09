# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "role_arn" {
  value = aws_iam_role.assume_role.arn
}
