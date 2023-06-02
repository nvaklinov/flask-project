#resource "kubernetes_service_account" "service-account" {
#  depends_on = [module.load_balancer_controller_irsa_role]
#  metadata {
#    name      = "aws-load-balancer-controller"
#    namespace = "kube-system"
#    labels = {
#      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
#      "app.kubernetes.io/component" = "controller"
#    }
#    annotations = {
#      "eks.amazonaws.com/role-arn"               = module.load_balancer_controller_irsa_role.iam_role_arn
#      "eks.amazonaws.com/sts-regional-endpoints" = "true"
#    }
#  }
#}

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

#resource "kubernetes_service_account" "secret-account" {
#  depends_on = [module.external_secrets_irsa_role]
#  metadata {
#    name      = "external-secret"
#    namespace = "kube-system"
##    labels = {
 #     "app.kubernetes.io/name"      = "external-secret"
 #     "app.kubernetes.io/component" = "external-secret"
 #   }
 #   annotations = {
 ##     "eks.amazonaws.com/role-arn"               = module.external_secrets_irsa_role.iam_role_arn
  ##    "eks.amazonaws.com/sts-regional-endpoints" = "true"
   # }
  #}
#}

#resource "kubernetes_service_account" "efs-account" {
#  depends_on = [module.efs_csi_irsa_role]
#  metadata {
#    name      = "efs-csi"
#    namespace = "kube-system"
#    labels = {
#      "app.kubernetes.io/name"      = "efs-csi"
#      "app.kubernetes.io/component" = "efs-csi"
#    }
#    annotations = {
#      "eks.amazonaws.com/role-arn"               = module.efs_csi_irsa_role.iam_role_arn
#      "eks.amazonaws.com/sts-regional-endpoints" = "true"
#    }
#  }
#}

#resource "helm_release" "aws-load-balancer-controller" {
#  depends_on = [kubernetes_service_account.service-account, module.vpc]
#  name       = "aws-load-balancer-controller"
#  atomic     = true
#  wait       = true

#  repository = "https://aws.github.io/eks-charts"
#  chart      = "aws-load-balancer-controller"
#  namespace  = "kube-system"
#  version    = "1.5.3"

#  set {
#    name  = "clusterName"
#    value = module.eks.cluster_name
#  }

#  set {
#    name  = "region"
#    value = "eu-central-1"
#  }

#  set {
#    name  = "vpcId"
#    value = module.vpc.vpc_id
#  }

#  set {
#    name  = "image.repository"
#    value = "602401143452.dkr.ecr.eu-west-2.amazonaws.com/amazon/aws-load-balancer-controller"
#  }

#  set {
#    name  = "serviceAccount.create"
#    value = "false"
#  }

 # set {
 ##   name  = "serviceAccount.name"
  #  value = "aws-load-balancer-controller"
  #}
#}



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

#resource "helm_release" "awspca" {
#  depends_on = [module.eks]
#  name       = "awspca"
#  atomic     = true
#  wait       = true
#  version    = "v1.2.5"

#  repository = "https://cert-manager.github.io/aws-privateca-issuer"
#  chart      = "aws-privateca-issuer"
#  namespace  = "kube-system"

#  set {
#    name  = "serviceAccount.create"
#    value = "false"
#  }

#  set {
#    name  = "serviceAccount.name"
#    value = "cert-manager"
#  }

#}

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
    value = "{nikvak.com}"
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

#resource "helm_release" "external_secrets" {
 # depends_on = [module.eks]
 # name       = "external-secrets"
 # repository = "https://charts.external-secrets.io"
 # chart      = "external-secrets"
 # version    = "0.7.2"
 # atomic     = true
 # wait       = true
 # namespace  = "kube-system"
 # set {
 #   name  = "serviceAccount.create"
 #   value = "false"
 # }

 # set {
 #   name  = "serviceAccount.name"
 #   value = "external-secret"
 # }
#}

#resource "helm_release" "prometheus_grafana" {
#  depends_on = [module.eks]
#  name       = "prometheus"
#  repository = "https://prometheus-community.github.io/helm-charts"
#  chart      = "prometheus-community/kube-prometheus-stack"
#  version    = "45.3.0"
#  atomic     = true
#  wait       = true
#  namespace  = "kube-system"
#}

#resource "helm_release" "loki" {
#  depends_on = [module.eks]
#  name       = "grafana-loki"
#  repository = "https://grafana.github.io/helm-charts"
#  chart      = "grafana/loki"
#  version    = "4.7.0"
#  atomic     = true
#  wait       = true
#  namespace  = "kube-system"
#}

#resource "helm_release" "promtail" {
#  depends_on = [module.eks]
#  name       = "promtail"
#  repository = "https://grafana.github.io/helm-charts"
#  chart      = "grafana/promtail"
#  version    = "6.9.0"
#  atomic     = true
#  wait       = true
#  namespace  = "kube-system"
#}


#resource "helm_release" "efs" {
#  depends_on = [module.eks]
#  name       = "efs-csi"
#  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
#  chart      = "aws-efs-csi-driver"
#  version    = "2.4.3"
#  atomic     = true
#  wait       = true
#  namespace  = "kube-system"
#  set {
#    name  = "controller.serviceAccount.create"
#    value = "false"
#  }
#  set {
#    name  = "controller.serviceAccount.name"
#    value = "efs-csi"
#  }
#}

#resource "helm_release" "nginx-ingress" {
#  depends_on = [module.eks]
#  name       = "nginx-ingress-controller"
#  repository = "https://charts.bitnami.com/bitnami"
#  chart      = "nginx-ingress-controller"
#  version    = "9.7.2"
#  atomic     = true
#  wait       = true
#  namespace  = "kube-system"
#  set {
#    name  = "service.type"
#    value = "LoadBalancer"
#  }
#  set {
#    name  = "publishService.enabled"
#    value = "true"
#  }
#}

