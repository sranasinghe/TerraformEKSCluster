# resource "aws_iam_role" "eks_test_worker" {
#     name = "eks_test_worker"
#     assume_role_policy = <<POLICY
#     {
#         "Version": "2012-10-17",
#         "Statement": [
#             {
#                 "Effect": "Allow",
#                 "Principal": {
#                     "Service": "ec2.amazonaws.com"
#                     },
#                     "Action": "sts:AssumeRole"
#                 }
#             ]
#     }
#     POLICY
# }

resource "aws_iam_role" "eks_test_worker" {
    name = "eks_test_worker"
    assume_role_policy = data.aws_iam_policy_document.eks_worker_policy.json
}

data "aws_iam_policy_document" "eks_worker_policy" {
  statement {
    actions =["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_test_worker_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks_test_worker.name
}

resource "aws_iam_role_policy_attachment" "eks_test_worker_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eks_test_worker.name
}

resource "aws_iam_role_policy_attachment" "eks_test_worker_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eks_test_worker.name
}

resource "aws_iam_instance_profile" "eks_test_worker" {
  name = "eks_test_worker-profile"
  role = aws_iam_role.eks_test_worker.name
}
