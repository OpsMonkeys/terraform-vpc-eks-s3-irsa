output "namespace" {
  description = "The name of the related namespace"
  value       = var.namespace
}

output "serviceaccount" {
  description = "The name of the related serviceaccount"
  value       = local.serviceaccount
}

output "irsa_role" {
  description = "The name of finegrained IAM role created"
  value       = var.enable_irsa ? aws_iam_role.role[0].arn : ""
}