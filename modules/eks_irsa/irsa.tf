resource "kubernetes_namespace" "ns" {
  count = var.create_namespace ? 1 : 0
  metadata {
    labels = {
      name = var.namespace
    }
    name = var.namespace
  }
}

locals {
  serviceaccount = var.serviceaccount != "" ? var.serviceaccount : var.namespace
}

resource "kubernetes_service_account" "sa" {
  count      = var.create_serviceaccount ? 1 : 0
  depends_on = [kubernetes_namespace.ns]

  automount_service_account_token = true

  metadata {
    name      = local.serviceaccount
    namespace = var.namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = var.enable_irsa ? "arn:aws:iam::${var.aws_account_id}:role/${var.cluster}-${local.serviceaccount}-role" : null
    }
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}
