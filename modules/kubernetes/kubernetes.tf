terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.6.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_id
}

provider "kubernetes" {
  experiments {
    manifest_resource = true
  }
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "kubernetes_practice" {
  metadata {
    name = "kubernetes-practice"
  }
}

resource "helm_release" "argocd" {
    name      = "argocd"
    repository = "https://argoproj.github.io/argo-helm"
    chart     = "argo-cd"
    namespace = "argocd"
}

# data "http" "argocd_installer_response" {
#   url = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
# }

# data "kubectl_file_documents" "argocd" {
#   depends_on = [
#     data.http.argocd_installer_response
#   ]
#   content = data.http.argocd_installer_response.body
# }

# # resource "kubectl_manifest" "argocd" {
# #   depends_on = [
# #     kubernetes_namespace.namespace,
# #     data.kubectl_file_documents.argocd
# #   ]
# #   count              = length(data.kubectl_file_documents.argocd.documents)
# #   yaml_body          = element(data.kubectl_file_documents.argocd.documents, count.index)
# #   override_namespace = "argocd"
# # }
