provider "aws" {
  region = "eu-central-1"
}
data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_name
}


provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.default.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.default.token
  }

}
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 19.0"
  cluster_name    = "${local.name}-cluster"
  cluster_version = "1.24"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnets
  enable_irsa     = true
  cluster_identity_providers = {
    sts = {
      client_id = "sts.amazonaws.com"
    }
  }
  eks_managed_node_group_defaults = {
    disk_size = 50
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
      instance_type = ["t2.micro"]
      capacity_type = "ON_DEMAND"
    }
  }
  cluster_endpoint_public_access = true
  manage_aws_auth_configmap      = true
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::699509601278:role/admin"
      username = "dynamoDBTemp"
      groups   = ["system:masters"]
    },
    {
      rolearn  = aws_iam_role.role.arn
      username = "${local.name}-role"
      groups   = ["system:masters"]
    }
  ]
  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id
  ]
}
module "load_balancer_controller_irsa_role" {
  depends_on                             = [module.eks]
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                                = "v5.20.0"
  role_name                              = "load-balancer-controller"
  attach_load_balancer_controller_policy = true
  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}
module "cert_manager_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  depends_on                    = [module.eks]
  version                       = "v5.11.2"
  role_name                     = "cert-manager"
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z01021041XQJXL9FAQE7B"]
  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cert-manager"]
    }
  }
}

module "external_dns_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  depends_on                    = [module.eks]
  version                       = "v5.11.2"
  role_name                     = "external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z01021041XQJXL9FAQE7B"]
  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }
}

/* resource "helm_release" "prometheus_grafana" {
  depends_on = [module.eks]
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "46.6.0"
  atomic     = true
  wait       = true
  namespace  = "kube-system"
} */

/* resource "helm_release" "loki" {
  depends_on = [module.eks]
  name       = "grafana-loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "5.6.1"
  atomic     = true
  wait       = true
  namespace  = "kube-system"
}

resource "helm_release" "promtail" {
  depends_on = [module.eks]
  name       = "promtail"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  version    = "6.11.2"
  atomic     = true
  wait       = true
  namespace  = "kube-system"
} */



