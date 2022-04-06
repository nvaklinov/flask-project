data "aws_eks_cluster" "cluster" {
  name = module.eks-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks-cluster.cluster_id
}

module "eks-cluster" {
  source            = "terraform-aws-modules/eks/aws"
  cluster_name      = "my-cluster"
  #  cluster_version = "1.18.16"
  subnet_ids        = [resource.aws_subnet.main.id, resource.aws_subnet.main2.id, resource.aws_subnet.main3.id]
  vpc_id            = resource.aws_vpc.main.id

}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  # load_config_file       = false
}
