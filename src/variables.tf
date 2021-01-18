variable "region" {
  description = "AWS Region"
  default     = "us-west-2"
}

#SET THESE ROLES TO YOUR TERRAFORM ROLES PER ACCOUNT
variable "role_arn" {
  description = "Role ARN"
  type        = map(string)

  default = {
    test = "arn:aws:iam::<account_id>:role/devops"
    stg  = "arn:aws:iam::<account_id>:role/devops"
    prd  = "arn:aws:iam::<account_id>:role/devops"
  }
}

#SET THESE TO YOUR AWS ACCOUNT ID
variable "aws_account_id" {
  description = "Account ID"
  type        = map(string)

  default = {
    test = "<account_id>"
    stg  = "<account_id>"
    prd  = "<account_id>"
  }
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "name" {
  description = "Name to be used"
  type        = string
  default     = "aws-vpc"
}

variable "cidr_block" {
  description = "VPC CIDR Block to use"
  type        = map(string)

  default = {
    test = "172.21.0.0/16"
    stg  = "172.22.0.0/16"
    prd  = "172.23.0.0/16"
  }
}

variable "availability_zones" {
  description = "Availability Zones to Use"
  type = object({
    test = list(string),
    stg  = list(string),
    prd  = list(string),
  })

  default = {
    test = ["us-west-2a", "us-west-2b", "us-west-2c"]
    stg  = ["us-west-2a", "us-west-2b", "us-west-2c"]
    prd  = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]
  }
}

variable "private_subnets" {
  description = "Private Subnets to use"
  type = object({
    test = list(string),
    stg  = list(string),
    prd  = list(string),
  })

  default = {
    test = ["172.21.1.0/24", "172.21.2.0/24", "172.21.3.0/24"]
    stg  = ["172.22.1.0/24", "172.22.2.0/24", "172.22.3.0/24"]
    prd  = ["172.23.1.0/24", "172.23.2.0/24", "172.23.3.0/24", "172.23.4.0/24", "172.23.5.0/24", "172.23.6.0/24"]
  }
}

variable "public_subnets" {
  description = "Public Subnets to use"
  type = object({
    test = list(string),
    stg  = list(string),
    prd  = list(string),
  })

  default = {
    test = ["172.21.11.0/24", "172.21.12.0/24", "172.21.13.0/24"]
    stg  = ["172.22.11.0/24", "172.22.12.0/24", "172.22.13.0/24"]
    prd  = ["172.23.11.0/24", "172.23.12.0/24", "172.23.13.0/24", "172.23.14.0/24", "172.23.15.0/24", "172.23.16.0/24"]
  }
}

variable "single_nat_gateway" {
  description = "Use a single NAT gateway or multiple"
  type        = map(string)

  default = {
    test = true
    stg  = true
    prd  = false
  }
}

## EKS Variables
variable "cluster_name" {
  description = "Name for EKS Cluster"
  type        = string
  default     = "aws-vpc"
}

variable "cluster_version" {
  description = "EKS Cluster Version to use"
  type        = map(string)

  default = {
    test = 1.18
    stg  = 1.18
    prd  = 1.18
  }
}

variable "instance_types" {
  description = "Instance types to use in nodegroup"
  type = object({
    test = list(string),
    stg  = list(string),
    prd  = list(string),
  })

  default = {
    test = ["t3.medium", "t3.large", "m4.large"]
    stg  = ["m5.large", "m5.xlarge", "m4.large"]
    prd  = ["m5.xlarge", "m5.2xlarge", "m4.xlarge"]
  }
}

variable "disk_size" {
  description = "Node disk size"
  type        = map(string)

  default = {
    test = "50"
    stg  = "80"
    prd  = "240"
  }
}

variable "log_retention" {
  description = "Log Retention in days"
  type        = map(string)

  default = {
    test = "7"
    stg  = "30"
    prd  = "30"
  }
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "<your account id>",
  ]
}

variable "asg_min_size" {
  description = "Autoscaling group min size"
  type        = map(string)

  default = {
    test = 2
    stg  = 3
    prd  = 3
  }
}

variable "asg_desired_capacity" {
  description = "Autoscaling group desired size"
  type        = map(string)

  default = {
    test = 2
    stg  = 3
    prd  = 3
  }
}

variable "on_demand_base_capacity" {
  description = "Autoscaling group on-demand base capacity"
  type        = map(string)

  default = {
    test = 0
    stg  = 1
    prd  = 3
  }
}

variable "on_demand_percentage_above_base_capacity" {
  description = "Autoscaling group on-demand percentage above base capacity"
  type        = map(string)

  default = {
    test = 0
    stg  = 0
    prd  = 25
  }
}

variable "asg_max_size" {
  description = "Autoscaling group max size"
  type        = map(string)

  default = {
    test = 3
    stg  = 9
    prd  = 9
  }
}

variable "spot_instance_pools" {
  description = "Autoscaling group number of spot instance pools"
  type        = map(string)

  default = {
    test = 3
    stg  = 3
    prd  = 3
  }
}

variable "datadog" {
  description = "Turn on datadog monitoring for hosts"
  type        = map(string)

  default = {
    test = false
    stg  = true
    prd  = true
  }
}
