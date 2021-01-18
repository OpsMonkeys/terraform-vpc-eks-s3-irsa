## Demo repo for AWS VPC, EKS Cluster, S3, and IRSA use

This repo walks through creating a VPC, it's associated components such as subnets (private and public), IGW, NAT gateway(s), routes, etc using the public module from the Terraform Registry. 

https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

It also creates a base EKS Kubernetes cluster using the public Terraform module. It uses a worker group made up of spot instances (or mix of on-demand and spot if you want) to keep it cheap for demo purposes. All nodes are provisioned to the private subnets.

https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

## Requirements

To use this repo for demo purposes you will need the following.
AWS Account (at least one, can do multiple)
AWS IAM Credentials with admin purposes (for demo)
AWS IAM Role with adminstrative privileges for Terraform to assume (multi-account setup)
AWS S3 Bucket to hold state
AWS cli installed and configured
Kubectl installed
Terraform 0.14.3 installed (I recommend using https://github.com/tfutils/tfenv)
Basic knowledge of AWS IAM, and Kubernetes components.

## To spin up
Add your roles, and account ID's to the variables.tf
Add your pre-existing S3 State bucket to main.tf

Run `terraform init -backend-configs=env/test/backend.tfvars src/`
Which will initialize your workspace and pull any providers needed such as AWS and the Kubernetes providers.

Then run a terraform plan `terraform plan -var 'env=test' src/`

If looks ok go ahead and run the apply `terraform apply -var 'env=test' src/`

Answer with yes when asked if you want to apply. It will take a bit to provision the VPC, related resources, the EKS cluster and related resources. Once done you need to setup your local kubectl for access by running `aws eks update-kubeconfig --region us-west-2 --name aws-vpc` or `aws eks update-kubeconfig --region us-west-2 --name aws-vpc --role arn:aws:iam::<account_id>:role/<name>` with whatever role you used to create the cluster (defined in variables).

## Kubernetes Testing
To deploy the demo app to test IRSA ability run:
`kubectl apply -f demo_irsa_app/ --dry-run=client`
if the dry run looks ok go ahead and apply it.
`kubectl apply -f demo_irsa_app/`

Once deployed you can describe the deployment, service account, etc and see how they are linked up.
Go ahead and climb on the container with
`kubectl exec -it <name of container> -- bin/bash`
Install the aws cli
`apt-get update`
`apt-get install awscli`
List buckets
`aws s3 ls`
Touch a file
`touch test.txt`
Upload to S3 bucket
`aws s3 cp test.txt s3://name-of-bucket`

You have now used Terraform to spin up a VPC, EKS Cluster, deployed a demo app that is using a service account to assume a IAM role and policy through OIDC. For more information please read up on IRSA here: https://aws.amazon.com/blogs/opensource/introducing-fine-grained-iam-roles-service-accounts/

## Tear Down
First empty your s3 bucket.
`terraform destroy -var 'env=test' src/`