module "aws_vpc" {
  # Module pulled from https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.63.0"

  name = var.name
  cidr = var.cidr_block[var.env]

  azs                   = var.availability_zones[var.env]
  private_subnets       = var.private_subnets[var.env]
  public_subnets        = var.public_subnets[var.env]
  single_nat_gateway    = var.single_nat_gateway[var.env]
  private_subnet_suffix = "pvt"
  public_subnet_suffix  = "pub"
  public_subnet_tags = {
    Mode                                    = "public"
    Cluster                                 = var.name
    "kubernetes.io/role/elb"                = 1
    "kubernetes.io/cluster/${var.name}"     = "shared"
  }
  private_subnet_tags = {
    Mode                                    = "private"
    Cluster                                 = var.name
    "kubernetes.io/role/internal-elb"       = 1
    "kubernetes.io/cluster/${var.name}"     = "shared"
  }

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true

  tags = {
    env     = var.env
    project = "terraform-vpc-eks-s3-irsa-demo"
    owner   = "yourself"
  }
}