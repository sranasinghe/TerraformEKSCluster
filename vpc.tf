module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"

  name = "AEM_vpc_eks"
  cidr = "10.0.0.0/16"
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["10.0.1.0/24" , "10.0.2.0/24" ,"10.0.3.0/24"]
  public_subnets = ["10.0.101.0/24" , "10.0.102.0/24" ,"10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
      "Name" = "vpc-eks"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"   
    }
  
   public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"   
    }
}
