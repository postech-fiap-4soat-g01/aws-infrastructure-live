resource "aws_iam_role" "eks-iam" {
  name = "eks-cluster-iam-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-iam.name
}

resource "aws_eks_cluster" "eks-cluster" {
  name    = "eks-${var.cluster_name}"
  role_arn = aws_iam_role.eks-iam.arn

  vpc_config = {
    aws_subnet.eks-private-us-east-1a.id,
    aws_subnet.eks-private-us-east-1b.id
  }

  depends_on = [aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy]
}
