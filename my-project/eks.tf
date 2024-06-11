provider "aws" {
  region = "us-east-1"
}

resource "aws_eks_cluster" "main" {
  name     = "my-eks-cluster"
  role_arn = "arn:aws:iam::712340109036:role/eks-cluster"

  vpc_config {
    subnet_ids = [
      aws_eks_cluster.main["subnet-07ee43f167f3e612c"].id,
      aws_eks_cluster.main["subnet-0ccfa04a7628f349a"].id
    ]
    security_group_ids = "sg-0855034ebbf977a75"
  }

}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "my-eks-node-group"
  node_role_arn   = "arn:aws:iam::712340109036:role/node-ec2-access"
  subnet_ids      =  [aws_subnet.main["subnet-07ee43f167f3e612c"].id, aws_subnet.main["subnet-0ccfa04a7628f349a"].id]


  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = "t3.medium"
}

