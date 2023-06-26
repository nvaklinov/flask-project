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

resource "null_resource" "run_local_exec" {
  depends_on = [module.eks]
  provisioner "local-exec" {
    command     = "aws eks update-kubeconfig --name=cluster --region=eu-central-1"
    interpreter = ["bash", "-c"]
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
    value = "{${var.domain}}"
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

module "external_dns_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  depends_on                    = [module.eks]
  version                       = "v5.11.2"
  role_name                     = "external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/${var.hosted_zone_id}"]
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

module "cert_manager_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  depends_on                    = [module.eks]
  version                       = "v5.11.2"
  role_name                     = "cert-manager"
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/${var.hosted_zone_id}"]
  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cert-manager"]
    }
  }
}

resource "kubernetes_service_account" "secret_account" {
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

  set {
    name  = "backend.awsSecretsManager.enabled"
    value = "true"
  }

  set {
    name  = "backend.awsSecretsManager.region"
    value = var.region
  }
}