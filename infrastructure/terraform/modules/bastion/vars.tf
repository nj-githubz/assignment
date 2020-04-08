variable "ami" {
  default = "ami-04763b3055de4860b"
}

variable "awsregion" {}

variable "region_ami_map" {
  type = "map"
  default = {
    eu-central-1 = "ami-050a22b7e0cf85dd0"
    eu-north-1   = "ami-7dd85203"
    eu-west-1    = "ami-03ef731cc103c9f09"
    eu-west-2    = "ami-0fab23d0250b9a47e"
    eu-west-3    = "ami-0bb607148d8cf36fb"
    us-east-1    = "ami-04763b3055de4860b"
    us-east-2    = "ami-0d03add87774b12c5"
    us-west-1    = "ami-0dbf5ea29a7fc7e05"
    us-west-2    = "ami-0994c095691a46fb5"
  }
}

variable "key_name" {}

variable "pemfile" {}

variable "subnet_id" {}

variable "bastion-securitygroup" {}
variable "subnet_id_public" {}
variable "eks-cluster-node" {}
variable "endpoint" {}
variable "certificate_authority" {}
variable "cluster-name" {}
variable "eks-cluster-node-role" {}

