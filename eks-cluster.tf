resource "aws_eks_cluster" "AEM_eks_cluster" {
    name = var.cluster_name
    role_arn = aws_iam_role.eks_test_cluster.arn

    vpc_config {
        security_group_ids = [aws_security_group.AEM_eks_cluster.id]
        subnet_ids = module.vpc.public_subnets
    }

    depends_on = [
        aws_iam_role_policy_attachment.eks_test_cluster_AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.eks_test_cluster_eks_test_cluster_AmazonEKSServicePolicy
    ]
}
