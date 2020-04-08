
provider "http" {}

#Create the VPC
resource "aws_vpc" "eks-cluster-vpc" {
  cidr_block           = "${var.vpc_cidr}"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = "${
    map(
      "Name", "eks-cluster-vpc",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}
