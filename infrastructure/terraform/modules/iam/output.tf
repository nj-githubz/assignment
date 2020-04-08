output "eks-cluster-node-instanceprofile" {
  value = "${aws_iam_instance_profile.eks-cluster-node}"
}

output "eks-cluster-iamrole" {
  value = "${aws_iam_role.eks-cluster-iamrole}"
}

output "cluster_policy" {
  value = "${aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy}"
}

output "service_policy" {
  value = "${aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy}"
}

output "eks-cluster-node-role" {
  value = "${aws_iam_role.eks-cluster-node}"
}

# output "eks-bastion-host-iamrole" {
#   value = "${aws_iam_instance_profile.eks-bastion-host.name}"
# }
