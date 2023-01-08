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
      instance_type = ["t2.large"]
      capacity_type = "ON_DEMAND"
    }
  }
  cluster_endpoint_public_access = true
  manage_aws_auth_configmap      = true

  aws_auth_roles = [
    {
      rolearn  = aws_iam_role.role.arn
      username = "${local.name}-role"
      groups   = ["system:masters"]
    },
  ]
  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id
  ]
}

resource "aws_security_group_rule" "allow_jenkins" {
  depends_on               = [module.vpc]
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.allow_tls.id
  security_group_id        = module.eks.cluster_primary_security_group_id
}
