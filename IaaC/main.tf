
data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_name
}

data "aws_caller_identity" "current" {}

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

############################### Cloud Provider #################################
# provider "aws" {
#   region = "us-east-1"
# }

# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~>4.0"
#     }

#     github = {
#       source  = "integrations/github"
#       version = ">= 5.9.1"
#     }
#     tls = {
#       source  = "hashicorp/tls"
#       version = ">= 4.0.4"
#     }
#   }
# }

############################ EKS Cluster ########################################
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 19.0"
  cluster_name    = "cluster"
  cluster_version = "1.24"
  vpc_id          = "vpc-0fb4d165e52a0d006"                                  # module.vpc.vpc_id
  subnet_ids      = ["subnet-01c1c970ab2ef985e", "subnet-09d69dd083192b7ea"] # module.vpc.public_subnets
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
      rolearn  = "arn:aws:iam::691662309979:role/admin" # aws_iam_role.role2.arn
      username = "svaklinov"
      groups   = ["system:masters"]
    },
  ]
  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id
  ]
}
############################### SECRET MANAGER create&role ##################################

module "external_secrets_irsa_role" {
  source     = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  depends_on = [module.eks]

  role_name                             = "external-secrets"
  attach_external_secrets_policy        = true
  external_secrets_secrets_manager_arns = ["arn:aws:secretsmanager:*:*:secret:*"]


  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-secret"]
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

# ################################ Nik Resource Copy&Paste ########################################

resource "helm_release" "external_secrets" {
  depends_on = [module.eks]
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.7.2"
  atomic     = true
  wait       = true
  namespace  = "kube-system"

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "external-secret"
  }
}


resource "helm_release" "nginx-ingress" {
  depends_on = [module.eks]
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  version    = "9.7.2"
  atomic     = true
  wait       = true
  namespace  = "kube-system"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "publishService.enabled"
    value = "true"
  }
}

resource "helm_release" "cert-manager" {
  depends_on = [module.eks]
  name       = "cert-manager"
  atomic     = true
  wait       = true
  version    = "1.11.0"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "kube-system"

  set {
    name  = "installCRDs"
    value = "true"
  }


  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "cert-manager"
  }
}

resource "helm_release" "external_dns" {
  depends_on = [module.eks]
  name       = "external-dns"
  chart      = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "6.13.2"
  namespace  = "kube-system"

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }

  set {
    name  = "sources"
    value = "{ingress}"
  }

  set {
    name  = "registry"
    value = "txt"
  }

  set {
    name  = "domainFilters"
    value = "{vaklinov.online}"
  }

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "txtPrefix"
    value = "prefix"
  }

  set {
    name  = "txtOwnerId"
    value = "Owner"
  }
}

############### DNS Hosted Zone ################################################  

module "external_dns_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  depends_on                    = [module.eks]
  version                       = "v5.11.2"
  role_name                     = "external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z0510421SU9CA6G8K7UL"]
  oidc_providers = {

    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }
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
      "eks.amazonaws.com/role-arn"               = module.external_dns_irsa_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}
######## Cert Manager and IRSA Role ############################################
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

module "cert_manager_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  depends_on                    = [module.eks]
  version                       = "v5.11.2"
  role_name                     = "cert-manager"
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z0510421SU9CA6G8K7UL"]
  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cert-manager"]
    }
  }
}