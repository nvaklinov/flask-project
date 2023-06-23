module "external_dns_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  depends_on                    = [module.eks]
  version                       = "v5.11.2"
  role_name                     = "external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/${var.hosted_zone}"]
  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }
}

module "cert_manager_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  depends_on                    = [module.eks]
  version                       = "v5.11.2"
  role_name                     = "cert-manager"
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/${var.hosted_zone}"]
  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cert-manager"]
    }
  }
}

module "external_secrets_irsa_role"{
    depends_on = [ module.eks ]
    source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
    version = "5.11.2"

    role_name = "external-secrets"
    attach_external_secrets_policy = true
    external_secrets_secrets_manager_arns = ["arn:aws:secretsmanager:*:*:secret:*"]

    oidc_providers = {
        ex = {
            provider_arn = module.eks.oidc_provider_arn
            namespace_service_accounts = ["kube-system:external-secret"]
        }
    }
}