module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

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
    disk_size = 20
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
      instance_type = ["t2.large"]
      capacity_type = "ON_DEMAND"
    }
  }
  cluster_endpoint_public_access = true
  manage_aws_auth_configmap      = true

  aws_auth_roles = [
    {
      rolearn  = aws_iam_role.role2.arn
      username = "${local.name}-role"
      groups   = ["system:masters"]
    },
  ]
  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id
  ]
}

#module "load_balancer_controller_irsa_role" {
##  depends_on = [module.eks]
##  source     = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
##  version    = "v5.20.0"
#
##  role_name                              = "load-balancer-controller"
##  attach_load_balancer_controller_policy = true
#
##  oidc_providers = {
##    ex = {
##      provider_arn               = module.eks.oidc_provider_arn
##      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
##    }
##  }
##}
#
##module "efs_csi_irsa_role" {
##  source     = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
##  depends_on = [module.eks]
##  version    = "v5.19.0"
##
##  role_name             = "efs-csi"
##  attach_efs_csi_policy = true
##
##  oidc_providers = {
##    ex = {
##      provider_arn               = module.eks.oidc_provider_arn
##      namespace_service_accounts = ["kube-system:efs-csi"]
##    }
##  }
##}
#
module "cert_manager_irsa_role" {
  source     = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  depends_on = [module.eks]
  version    = "v5.11.2"

  role_name                     = "cert-manager"
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z08350721PUJZARV31GMB"]
  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cert-manager"]
    }
  }
}
#
module "external_dns_irsa_role" {
  source     = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  depends_on = [module.eks]
  version    = "v5.11.2"

  role_name                     = "external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z08350721PUJZARV31GMB"]

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }
}

module "external_secrets_irsa_role" {
  source     = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  depends_on = [module.eks]
  version    = "v5.11.2"

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
