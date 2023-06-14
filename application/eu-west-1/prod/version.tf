provider "aws" {
  region = local.region
}
provider "kubernetes" {
  host                   = var.create_eks ? module.eks.cluster_endpoint : ""
  cluster_ca_certificate = var.create_eks ? base64decode(module.eks.cluster_ca_certificate) : ""
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
    command     = "aws"
  }
}
provider "helm" {
  kubernetes {
    host                   = var.create_eks ? module.eks.cluster_endpoint : ""
    cluster_ca_certificate = var.create_eks ? base64decode(module.eks.cluster_ca_certificate) : ""
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
      command     = "aws"
    }
  }
}
terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20.0"
    }
  }
  required_version = "~> 1.2"
  backend "s3" {
    encrypt = true
    bucket  = "sg-bacon-tf-state"
    region  = "eu-west-1"
    key     = "state.tfstate"
  }
}
