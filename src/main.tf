terraform {
  backend "s3" {
    bucket = "play-tfstate" #Put your bucket here
    region = "us-west-2"
    acl    = "bucket-owner-full-control"
  }
}

provider "aws" {
  profile = "default"
  region  = var.region

  assume_role {
    role_arn = var.role_arn[var.env]
  }
}

provider "kubernetes" {
  load_config_file         = "false"
  host                     = module.aws_vpc_eks.cluster_endpoint
  cluster_ca_certificate   = base64decode(module.aws_vpc_eks.cluster_certificate_authority_data)
  config_context_auth_info = "aws"
  config_context_cluster   = "kubernetes"
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws-iam-authenticator"
    args = [
      "token",
      "-i",
      var.cluster_name,
      "-r",
      var.role_arn[var.env]
    ]
  }
}