#data "aws_eks_cluster" "cluster" {
#  name = module.eks-cluster.cluster_id
#}

#data "aws_eks_cluster_auth" "cluster" {
#  name = module.eks-cluster.cluster_id
#}

module "eks-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-cluster"
# cluster_version = "1.21.5"
  subnet_ids          = ["subnet-05b45d1f030bb0f65","subnet-0cd73545e17667d5d","subnet-061ae723ff3b547a0"]
  vpc_id           = "vpc-0e837a81fd41bd5df"

}

#provider "kubernetes" {
#    host                   = data.aws_eks_cluster.cluster.endpoint
#    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#    token                  = data.aws_eks_cluster_auth.cluster.token
#}

