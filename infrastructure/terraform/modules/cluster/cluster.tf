resource "aws_eks_cluster" "eks-cluster" {
  name     = "${var.cluster-name}"
  role_arn = "${var.eks-cluster-iamrole.arn}"

  vpc_config {
    security_group_ids = ["${var.eks-cluster-securitygroup.id}"]
    subnet_ids         = "${var.subnet_id}"
  }

  depends_on = [
    "var.cluster_policy",
    "var.service_policy",
  ]
}
