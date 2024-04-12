provider "aws" {
  region = "ap-south-1"
}

module "eks_cluster" {
  source  = "github.com/terraform-aws-modules/terraform-aws-eks"
  # Use a specific tag or branch for the eks_cluster module
  ref     = "master"  # Replace "master" with the appropriate branch or tag

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.25"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets

  node_groups = {
    eks_nodes = {
      desired_capacity = 1
      instance_type    = "t3.medium"
      key_name         = "node-ec2"
    }
  }

  tags = {
    Environment = "Development"
  }
}

module "vpc" {
  source  = "github.com/terraform-aws-modules/terraform-aws-vpc"
  # Use a specific tag or branch for the vpc module
  ref     = "master"  # Replace "master" with the appropriate branch or tag

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_dns_support   = true
  enable_dns_hostnames = true
}

module "kms" {
  source = "github.com/terraform-aws-modules/terraform-aws-kms"
  # Use a specific tag or branch for the kms module
  ref    = "master"  # Replace "master" with the appropriate branch or tag

  # Specify module configuration here
  # (e.g., key_name, description, enable_key_rotation, etc.)
}
