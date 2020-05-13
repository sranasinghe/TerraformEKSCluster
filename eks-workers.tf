data "aws_ami" "eks_worker_ami"{
    filter {
        name = "name"
        values = ["amazon-eks-node-${aws_eks_cluster.AEM_eks_cluster.version}-v*"]
    }
    
    most_recent = true
    owners      = ["602401143452"]
}   

locals {
  eks-worker-userdata =  <<USERDATA
  #!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.AEM_eks_cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.AEM_eks_cluster.certificate_authority[0].data}' '${var.cluster_name}'
  USERDATA
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = var.cluster_name
  node_group_name = "eks_node_group"
  node_role_arn   = aws_iam_role.eks_test_worker.arn
  subnet_ids      = module.vpc.public_subnets
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  instance_types  = ["t2.large"]

  depends_on = [
        aws_iam_role_policy_attachment.eks_test_worker_AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.eks_test_worker_AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.eks_test_worker_AmazonEC2ContainerRegistryReadOnly
    ]
}

# resource "aws_launch_configuration" "aws_launch_config" {
#     associate_public_ip_address = true
#     iam_instance_profile = aws_iam_instance_profile.eks_test_worker.name
#     image_id = data.aws_ami.eks_worker_ami.id
#     instance_type = "t2.large"
#     name_prefix = "AEM-eks-lconfig"
#     security_groups = [aws_security_group.AEM_eks_worker.id]
#     user_data_base64 = base64encode(local.eks-worker-userdata)

#     lifecycle {
#         create_before_destroy  = true
#     }
# }

# resource "aws_autoscaling_group" "asg" {
#     desired_capacity = 2
#     launch_configuration = aws_launch_configuration.aws_launch_config.id
#     #launch_configuration = "aws-launch-config"
#     max_size = 3
#     min_size = 1
#     name    = "eks-asg"
#     vpc_zone_identifier = module.vpc.public_subnets

#     tag {
#         key = "name"
#         value = "eks-asg"
#         propagate_at_launch = true
#     }
# }

