data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = [
      "*",
    ]
  }
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.irsa.arn,
      "${aws_s3_bucket.irsa.arn}/*"
    ]
  }
}

module "s3_policy_role" {
  source                = "../modules/eks_irsa"
  enable_irsa           = true
  namespace             = "default"
  serviceaccount        = "s3-policy"
  create_serviceaccount = true
  cluster               = var.cluster_name
  issuer_url            = replace(module.aws_vpc_eks.cluster_oidc_issuer_url, "https://", "")
  aws_account_id        = var.aws_account_id[var.env]
  policy                = data.aws_iam_policy_document.s3_policy.json
}
