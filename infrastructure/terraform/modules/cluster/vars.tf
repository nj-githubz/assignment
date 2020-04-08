variable "cluster-name" {
  # default = "revolut-eks-cluster"
}

variable "eks-cluster-securitygroup" {}
variable "eks-cluster-iamrole" {}
variable "subnet_id" {}

variable "cluster_policy" {}
variable "service_policy" {}
