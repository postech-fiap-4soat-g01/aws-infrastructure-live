variable "vpc_id" {}
variable "security_group_id" {}
variable "private_subnets_ids" {}
variable "eks_cluster_arn" {
  description = "ARN of the EKS cluster"
}