data "aws_iam_policy_document" "role" {
  count = var.enable_irsa ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${var.issuer_url}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${local.serviceaccount}"]
    }

    principals {
      identifiers = ["arn:aws:iam::${var.aws_account_id}:oidc-provider/${var.issuer_url}"]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "role" {
  count              = var.enable_irsa ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.role[0].json
  name               = "${var.cluster}-${local.serviceaccount}-role"
}

resource "aws_iam_policy" "policy" {
  count  = var.enable_irsa ? 1 : 0
  name   = "${var.cluster}-${local.serviceaccount}-policy"
  path   = "/"
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "attach" {
  count      = var.enable_irsa ? 1 : 0
  policy_arn = aws_iam_policy.policy[0].arn
  role       = aws_iam_role.role[0].name
}
