resource "aws_security_group" "AEM_eks_cluster" {
   name  = "AEM_eks_cluster"  
   description = "to communicate with workers"
   vpc_id = module.vpc.vpc_id

   egress {
       from_port = 0
       to_port = 0
       protocol = "-1"
       cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
       Name = "AEM_eks_cluster"
   }
}

resource "aws_security_group_rule" "AEM_eks_cluster_ingress_workers" {
  description = "Allow communicate k8s pods and api server"
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.AEM_eks_cluster.id
  source_security_group_id = aws_security_group.AEM_eks_worker.id
  to_port =  443
  type = "ingress"

}

resource "aws_security_group_rule" "AEM_eks_cluster_ingress_host" {
  description = "Allow host to communicate with the api server"
  cidr_blocks = [local.host_external_cidr]
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.AEM_eks_cluster.id
  to_port = 443
  type = "ingress"
}
