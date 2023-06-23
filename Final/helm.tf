resource "helm_release" "nginx-ingress" {
  depends_on = [module.eks, kubernetes_service_account.dns-account, kubernetes_service_account.cert-account]
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
  depends_on = [module.eks, kubernetes_service_account.dns-account, kubernetes_service_account.cert-account]
  name       = "cert-manager-1"
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
  depends_on = [module.eks, kubernetes_service_account.dns-account, kubernetes_service_account.cert-account]
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