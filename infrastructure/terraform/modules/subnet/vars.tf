variable "vpc_id" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}


variable "cluster-name" {}

variable "public-cidr" {
  # default = "10.0.3.0/24"
}

variable "private-cidr" {}
