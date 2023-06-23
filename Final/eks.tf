data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_name
}
data "aws_caller_identity" "current" {}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 19.0"
  cluster_name    = "cluster"
  cluster_version = "1.24"
  vpc_id          = var.vpc
  subnet_ids      = var.subnets
  enable_irsa     = true
  cluster_identity_providers = {
    sts = {
      client_id = "sts.amazonaws.com"
    }
  }
  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["t3.medium"]
  }
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }
  eks_managed_node_groups = {
    general = {
      desired_size = 2
      min_size     = 1
      max_size     = 3
      labels = {
        role = "general"
      }
      capacity_type = "ON_DEMAND"
    }
  }
  cluster_endpoint_public_access = true
  manage_aws_auth_configmap      = true
  aws_auth_roles = [
    {
      rolearn  = var.role_arn
      username = var.user
      groups   = ["system:masters"]
    },
  ]
  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id
  ]
}



resource "kubernetes_service_account" "dns-account" {
  depends_on = [module.external_dns_irsa_role]
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "external-dns"
      "app.kubernetes.io/component" = "external-dns"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"                = module.external_dns_irsa_role.iam_role_arn
      "eks.amazonaws.com/sts-regional0-endpoints" = "true"
    }
  }
}

resource "kubernetes_service_account" "cert-account" {
  depends_on = [module.cert_manager_irsa_role]
  metadata {
    name      = "cert-manager"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "cert-manager"
      "app.kubernetes.io/component" = "cert-manager"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.cert_manager_irsa_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}



resource "kubernetes_service_account" "secret-account" {
  depends_on = [module.external_secrets_irsa_role]
  metadata {
    name      = "external-secret"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "external-secret"
      "app.kubernetes.io/component" = "external-secret"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.external_secrets_irsa_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}
