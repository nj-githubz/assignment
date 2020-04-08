resource "aws_iam_role" "eks-cluster-iamrole" {
  name = "eks-cluster-iamrole"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "eks-cluster-node" {
  name = "eks-cluster-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# resource "aws_iam_role" "eks-bastion-host" {
#   name               = "eks-bastion-host"
#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": ["eks.amazonaws.com",
#                   "ec2.amazonaws.com"]
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_role_policy_attachment" "eks-bastion-host" {
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
#   role = "${aws_iam_role.eks-bastion-host.name}"
# }

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eks-cluster-iamrole.name}"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.eks-cluster-iamrole.name}"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.eks-cluster-node.name}"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.eks-cluster-node.name}"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.eks-cluster-node.name}"
}

resource "aws_iam_instance_profile" "eks-cluster-node" {
  name = "eks-cluster-node"
  role = "${aws_iam_role.eks-cluster-node.name}"
}

# resource "aws_iam_instance_profile" "eks-bastion-host" {
#   name = "eks-bastion-host"
#   role = "${aws_iam_role.eks-bastion-host.name}"
# }
