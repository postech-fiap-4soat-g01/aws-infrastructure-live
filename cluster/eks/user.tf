resource "aws_iam_policy" "eks_view_resources_policy" {
  name        = "EKSViewResourcesPolicy"
  description = "Policy to allow a principal to view Kubernetes resources for all clusters in the account"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:ListFargateProfiles",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:ListUpdates",
          "eks:AccessKubernetesApi",
          "eks:ListAddons",
          "eks:DescribeCluster",
          "eks:DescribeAddonVersions",
          "eks:ListClusters",
          "eks:ListIdentityProviderConfigs",
          "iam:ListRoles"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "ssm:GetParameter"
        Resource = "arn:aws:ssm:*:653706844093:parameter/*"
      }
    ]
  })
}

resource "aws_iam_role" "eks_connector_agent_role" {
  name = "AmazonEKSConnectorAgentRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "eks_connector_agent_policy" {
  name = "AmazonEKSConnectorAgentPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SsmControlChannel"
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel"
        ]
        Resource = "arn:aws:eks:*:*:cluster/*"
      },
      {
        Sid    = "ssmDataplaneOperations"
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenDataChannel",
          "ssmmessages:OpenControlChannel"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_connector_agent_role.name
}

resource "aws_iam_role_policy_attachment" "eks_connector_agent_custom_policy_attachment" {
  policy_arn = aws_iam_policy.eks_connector_agent_policy.arn
  role       = aws_iam_role.eks_connector_agent_role.name
}