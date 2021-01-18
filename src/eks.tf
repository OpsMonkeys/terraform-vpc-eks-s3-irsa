module "aws_vpc_eks" {
  # Module pulled from https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
  source                                         = "terraform-aws-modules/eks/aws"
  version                                        = "13.1.0"
  cluster_enabled_log_types                      = ["api", "audit"]
  cluster_log_retention_in_days                  = var.log_retention[var.env]
  cluster_name                                   = var.cluster_name
  cluster_version                                = var.cluster_version[var.env]
  subnets                                        = module.aws_vpc.private_subnets
  vpc_id                                         = module.aws_vpc.vpc_id
  write_kubeconfig                               = false
  cluster_create_endpoint_private_access_sg_rule = true
  cluster_endpoint_private_access_cidrs          = [var.cidr_block[var.env]]
  cluster_endpoint_private_access                = true
  cluster_endpoint_public_access                 = true
  enable_irsa                                    = true

  map_accounts = var.map_accounts
  map_roles = [
    {
      rolearn  = var.role_arn[var.env]
      username = "DevOps"
      groups   = ["system:masters"]
    },
  ]

  map_users = [
  ]

  worker_groups_launch_template = [{
    name                    = "mixed-demand-spot"
    override_instance_types = var.instance_types[var.env]
    root_encrypted          = true
    root_volume_size        = var.disk_size[var.env]

    asg_min_size                             = var.asg_min_size[var.env]
    asg_desired_capacity                     = var.asg_desired_capacity[var.env]
    on_demand_base_capacity                  = var.on_demand_base_capacity[var.env]
    on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity[var.env]
    asg_max_size                             = var.asg_max_size[var.env]
    spot_instance_pools                      = var.spot_instance_pools[var.env]
    subnets                                  = module.aws_vpc.private_subnets
    kubelet_extra_args                       = "--node-labels=node.kubernetes.io/lifecycle=`curl -s http://169.254.169.254/latest/meta-data/instance-life-cycle`"
  }]

  workers_group_defaults = {
    tags = [
      {
        "key"                 = "k8s.io/cluster-autoscaler/enabled"
        "propagate_at_launch" = "false"
        "value"               = "true"
      },
      {
        "key"                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
        "propagate_at_launch" = "false"
        "value"               = "true"
      }
    ]
  }

  tags = {
    env     = var.env
    project = "aws-vpc"
    owner   = "opsmonkeys"
  }
}
