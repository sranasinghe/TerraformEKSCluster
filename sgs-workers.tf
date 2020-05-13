resource "aws_security_group" "AEM_eks_worker" {
   name  = "AEM_eks_worker"  
   description = "to communicate with workers"
   vpc_id = module.vpc.vpc_id

   egress {
       from_port = 0
       to_port = 0
       protocol = "-1"
       cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
       Name = "AEM_eks_worker"
       "kubernetes.io/cluster/${var.cluster_name}" = "owned"
   }
}

resource "aws_security_group_rule" "AEM_eks_worker_ingress_workers" {

    description = " workers to communicate with each other"
    from_port = 0
    protocol = "-1"
    security_group_id = aws_security_group.AEM_eks_worker.id
    source_security_group_id = aws_security_group.AEM_eks_worker.id
    to_port = 65535
    type = "ingress"
}

resource "aws_security_group_rule" "AEM_eks_ingress_cluster" {
  description = " workers and pods to do communication from the cluster control plane"
  from_port = 1025
  protocol = "tcp"
  security_group_id = aws_security_group.AEM_eks_worker.id
  source_security_group_id = aws_security_group.AEM_eks_cluster.id
  to_port = 65535
  type = "ingress"
}





