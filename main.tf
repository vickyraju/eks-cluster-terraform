provider "aws" {
  region = "ap-south-1"
}

module "eks_cluster" {
  source  = "github.com/terraform-aws-modules/terraform-aws-eks"
  # Instead of version, specify ref (branch or tag)
  ref     = "master"  # Use the master branch

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
  # Instead of version, specify ref (branch or tag)
  ref     = "master"  # Use the master branch

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_dns_support   = true
  enable_dns_hostnames = true
}
