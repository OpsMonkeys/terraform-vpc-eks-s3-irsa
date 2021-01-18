variable "namespace" {
  description = "Name of Kubernetes namespace"
}

variable "serviceaccount" {
  description = "Name of Kubernetes serviceaccount"
  default     = ""
}

variable "cluster" {
  description = "Name of Kubernetes cluster"
  default     = ""
}

variable "create_namespace" {
  description = "Enables creating the namespace"
  default     = false
}

variable "create_serviceaccount" {
  description = "Enables creating a serviceaccount"
  default     = false
}

variable "enable_irsa" {
  description = "Add irsa role for the serviceaccount"
  default     = false
}

variable "policy" {
  description = "Policy json to apply to the irsa role"
  default     = ""
}

variable "issuer_url" {
  description = "EKS cluster OIDC url"
  default     = ""
}

variable "aws_account_id" {
  description = "AWS account id to configure irsa role"
  default     = ""
}