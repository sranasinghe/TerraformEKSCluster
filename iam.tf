# resource "aws_iam_role" "eks_test_cluster" {
#     name = "eks_test_cluster"
    
#     assume_role_policy = <<POLICY
#     {
#     "Version": "2012-10-17",
#         "Statement": [
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "eka.amazonaws.com"
#             },
#             "Action": "sts:AssumeRole"
#         }
#     ]
#     }
#     POLICY
# }

resource "aws_iam_role" "eks_test_cluster" {
    name = "eks_test_cluster"
    assume_role_policy = data.aws_iam_policy_document.eks_cluster_policy.json
}

data "aws_iam_policy_document" "eks_cluster_policy" {
  statement {
    actions =["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_test_cluster_AmazonEKSClusterPolicy" {
    policy_arn ="arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks_test_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_test_cluster_eks_test_cluster_AmazonEKSServicePolicy" {
   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
   role = aws_iam_role.eks_test_cluster.name
}

