data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.eks-cluster.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}
locals {
  eks-cluster-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${var.eks-cluster.endpoint}' --b64-cluster-ca '${var.eks-cluster.certificate_authority.0.data}' '${var.cluster-name}'
USERDATA
}

resource "aws_launch_configuration" "eks-cluster-launchconfiguration" {
  associate_public_ip_address = false
  iam_instance_profile        = "${var.eks-cluster-node.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "m4.large"
  name_prefix                 = "revolut-eks-cluster"
  security_groups             = ["${var.eks-cluster-node.id}"]
  user_data_base64            = "${base64encode(local.eks-cluster-node-userdata)}"
  key_name                    = "${var.key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks-cluster-autoscalegroup" {
  count                = "${var.autoscale_min_count <= var.autoscale_max_count && var.autoscale_desired_count <= var.autoscale_max_count && var.autoscale_desired_count >= var.autoscale_min_count ? 1 : 0}"
  desired_capacity     = "${var.autoscale_desired_count}"
  launch_configuration = "${aws_launch_configuration.eks-cluster-launchconfiguration.id}"
  max_size             = "${var.autoscale_max_count}"
  min_size             = "${var.autoscale_min_count}"
  name                 = "eks-cluster"
  vpc_zone_identifier  = "${var.subnet_id}"

  tag {
    key                 = "Name"
    value               = "${var.cluster-name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
