data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "foo" {
  name               = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-transfer-user-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "foo" {
  statement {
    sid     = "AllowFullAccesstoS3"
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "${aws_s3_bucket.sftp_gateway_bucket.arn}/*",
      "${aws_s3_bucket.sftp_gateway_bucket.arn}"
    ]
  }
}

data "aws_iam_policy_document" "sftp_user_policy" {
  statement {
    sid     = "AllowFullAccesstoS3"
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::$${transfer:HomeBucket}",
      "arn:aws:s3:::$${transfer:HomeBucket}*"
    ]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "$${transfer:UserName}/*",
        "$${transfer:UserName}"
      ]
    }
  }
}

resource "aws_iam_role_policy" "foo" {
  name   = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-transfer-user-iam-policy"
  role   = aws_iam_role.foo.id
  policy = data.aws_iam_policy_document.foo.json
}

resource "aws_transfer_user" "foo" {
  server_id = aws_transfer_server.sftp_gateway.id
  user_name = "tftestuser"
  role      = aws_iam_role.foo.arn
  #   policy    = data.aws_iam_policy_document.sftp_user_policy.json

  home_directory_type = "LOGICAL"
  home_directory_mappings {
    entry  = "/"
    target = "/${aws_s3_bucket.sftp_gateway_bucket.id}"
  }
}

resource "aws_transfer_ssh_key" "key1" {
  server_id = aws_transfer_server.sftp_gateway.id
  user_name = aws_transfer_user.foo.user_name
  body      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYrU60FUaUAXMA16RVcNBL9IJtTtSnpxoVkVGY67sdAq7mm9mL/c9dWgpg6qNkZ4OX1zJlHDvAEnRGbBBB6tww7PseRwt70tUE141G1gTZjE8dBsH60CPzyv6ymJkawb6Ql97bLao06lLKIwgislhmBSHTT7x80s3QnxM/7GKG/K5v75KThLOGkbpJu+p0Pb6u+2wXvRZliIIRWffMwas3CvAXljPj8yratyne0/jnzU/xgdp82OBruE6p+2o1dGQVwV2KwBkc8XS6vB67P23cWeE7dicN7tlfCUAI6WRi8FfNeSN6pasaUH4cStBuAOWrbjHAk5Hln0yLyZt9hVlH/2q5DXvT/iZpnOc/2Y7uRFgaTwtBAzQxV4HeeXRcsJR3vgpGcAu4BjRg2AhBeO2e2F1kIe0y4Vi8CG17heJ0wu5in7/2XGuaUH17nqZNBeSxNiSk03Vw+LLU44tN+asszPn4VQ2J4vxx/Xb6vSi4IPA+PPLBo3ruw8YtlVWHwxE= parikatla@USARRPARIKATLA3"
}

resource "aws_transfer_ssh_key" "key2" {
  server_id = aws_transfer_server.sftp_gateway.id
  user_name = aws_transfer_user.foo.user_name
  body      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB4+tVSF+1xKlaBo/Pr1mlX1nV5WhlYH1PHwPTZ5vx8N parikatla@USARRPARIKATLA3"
}

resource "aws_iam_role" "dpa_user" {
  name               = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-transfer-user-iam-role-dpa-user"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_transfer_user" "dpa_printing_facility_user" {
  server_id = aws_transfer_server.sftp_gateway.id
  user_name = "dpa_user"
  role      = aws_iam_role.dpa_user.arn

  home_directory_type = "LOGICAL"
  home_directory_mappings {
    entry  = "/"
    target = "/${aws_s3_bucket.sftp_gateway_bucket.id}/PrintAndMail/Outbound"
  }
}

data "aws_iam_policy_document" "dpa_user" {
  statement {
    sid     = "AllowFullAccesstoS3"
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "${aws_s3_bucket.sftp_gateway_bucket.arn}/*",
      "${aws_s3_bucket.sftp_gateway_bucket.arn}"
    ]
  }
}

resource "aws_iam_role_policy" "dpa_user" {
  name   = "${var.tags.agency}-${var.tags.project}-${var.tags.environment}-transfer-user-iam-dpa-policy"
  role   = aws_iam_role.dpa_user.id
  policy = data.aws_iam_policy_document.dpa_user.json
}

resource "aws_transfer_ssh_key" "dpa_key1" {
  server_id = aws_transfer_server.sftp_gateway.id
  user_name = aws_transfer_user.dpa_printing_facility_user.user_name
  body      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYrU60FUaUAXMA16RVcNBL9IJtTtSnpxoVkVGY67sdAq7mm9mL/c9dWgpg6qNkZ4OX1zJlHDvAEnRGbBBB6tww7PseRwt70tUE141G1gTZjE8dBsH60CPzyv6ymJkawb6Ql97bLao06lLKIwgislhmBSHTT7x80s3QnxM/7GKG/K5v75KThLOGkbpJu+p0Pb6u+2wXvRZliIIRWffMwas3CvAXljPj8yratyne0/jnzU/xgdp82OBruE6p+2o1dGQVwV2KwBkc8XS6vB67P23cWeE7dicN7tlfCUAI6WRi8FfNeSN6pasaUH4cStBuAOWrbjHAk5Hln0yLyZt9hVlH/2q5DXvT/iZpnOc/2Y7uRFgaTwtBAzQxV4HeeXRcsJR3vgpGcAu4BjRg2AhBeO2e2F1kIe0y4Vi8CG17heJ0wu5in7/2XGuaUH17nqZNBeSxNiSk03Vw+LLU44tN+asszPn4VQ2J4vxx/Xb6vSi4IPA+PPLBo3ruw8YtlVWHwxE= parikatla@USARRPARIKATLA3"
}

resource "aws_transfer_ssh_key" "dpa_key2" {
  server_id = aws_transfer_server.sftp_gateway.id
  user_name = aws_transfer_user.dpa_printing_facility_user.user_name
  body      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB4+tVSF+1xKlaBo/Pr1mlX1nV5WhlYH1PHwPTZ5vx8N parikatla@USARRPARIKATLA3"
}

resource "aws_transfer_ssh_key" "dpa_key3" {
  server_id = aws_transfer_server.sftp_gateway.id
  user_name = aws_transfer_user.dpa_printing_facility_user.user_name
  body      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINvjKR8ADenuMlotCiq8yMWDyYms8KDCWUU3I8c7ebwl parikatla@USARRPARIKATLA3"
}

resource "aws_transfer_user" "payment_us_bank_user" {
  server_id = aws_transfer_server.sftp_gateway.id
  user_name = "payment_user"
  role      = aws_iam_role.dpa_user.arn

  home_directory_type = "LOGICAL"
  home_directory_mappings {
    entry  = "/"
    target = "/${aws_s3_bucket.sftp_gateway_bucket.id}/Payments"
  }
}

resource "aws_transfer_ssh_key" "payment_us_bank_user_key" {
  server_id = aws_transfer_server.sftp_gateway.id
  user_name = aws_transfer_user.payment_us_bank_user.user_name
  body      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAz1OuyLPVGdAQsb8pyNjW1hSk6N/lBysnosVCwM1cSu parikatla@USARRPARIKATLA3"
}