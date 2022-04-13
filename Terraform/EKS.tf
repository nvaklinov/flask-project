module "eks-cluster" {
	source          = "terraform-aws-modules/eks/aws"
	version         = "17.24.0"
	cluster_name    = "FlaskApp-Cluster"
	cluster_version = "1.21"
	subnets         = ["subnet-05b45d1f030bb0f65","subnet-0cd73545e17667d5d","subnet-061ae723ff3b547a0"]
	vpc_id = "vpc-0e837a81fd41bd5df"

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "DevOps_WorkerGroup"
      instance_type                 = "t2.micro"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = ["sg-0615cea759293cfc7","sg-0a5c4c23507fe2bb3"]
      asg_desired_capacity          = 1
    }
]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks-cluster.cluster_id
}
