provider "aws" {
  region = "eu-north-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }

  required_version = ">= 1.3.0"
}

# ---- EKS Cluster ----
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "cloud-hustlers-eks-cluster"
  kubernetes_version = "1.33"

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    example = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]

      min_size     = 2
      max_size     = 2
      desired_size = 2
    }
  }


  vpc_id     = "vpc-0443bf9cd35af0848"
  subnet_ids = ["subnet-027666b5fef188302", "subnet-0e222bbc722878254"]

  tags = {
    Owner     = "Cloud-Hustlers"
    Terraform = "true"
  }
}
