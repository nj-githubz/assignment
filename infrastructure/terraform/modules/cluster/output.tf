output "eks-cluster" {
  value = "${aws_eks_cluster.eks-cluster}"
}

output "cluster-name" {
  value = "${var.cluster-name}"
}
