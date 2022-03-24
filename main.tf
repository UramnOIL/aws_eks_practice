terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.6.0"
    }
  }
}

locals {
  azs     = ["ap-northeast-1a", "ap-northeast-1c"]
  subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  cidr    = "10.0.0.0/16"
}

provider "aws" {
  region = "ap-northeast-1"
}

module "vpc" {
  source         = "./modules/vpc"
  azs            = local.azs
  cidr           = local.cidr
  public_subnets = local.subnets
}

module "eks" {
  source     = "./modules/eks"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids_for_eks
}

module "kubernetes" {
  source     = "./modules/kubernetes"
  cluster_id = module.eks.cluster_id
}
