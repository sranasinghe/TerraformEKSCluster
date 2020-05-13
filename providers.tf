provider "aws" {
  region = "us-east-2"
}

provider "http" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}
