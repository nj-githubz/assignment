output "eks-cluster-autoscalegroup" {
  value = "${aws_autoscaling_group.eks-cluster-autoscalegroup[*]}"
}

output "eks-cluster-launchconfiguration" {
  value = ["${aws_launch_configuration.eks-cluster-launchconfiguration}"]
}
