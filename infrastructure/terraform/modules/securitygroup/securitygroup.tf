resource "aws_security_group" "eks-cluster-securitygroup" {
  name        = "eks-cluster-securitygroup"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "${var.external_cidr}"
  }

  tags = {
    Name = "eks-cluster-securitygroup"
  }
}

resource "aws_security_group_rule" "eks-cluster-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-cluster-securitygroup.id}"
  source_security_group_id = "${aws_security_group.eks-cluster-node.id}"
  to_port                  = 443
  type                     = "ingress"
}


resource "aws_security_group" "eks-cluster-node" {
  name        = "eks-cluster-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "${var.external_cidr}"
  }

  tags = {
    Name = "eks-cluster-securitygroup-node"
  }
}

resource "aws_security_group_rule" "eks-cluster-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.eks-cluster-node.id}"
  source_security_group_id = "${aws_security_group.eks-cluster-node.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-cluster-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 443 
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-cluster-node.id}"
  source_security_group_id = "${aws_security_group.eks-cluster-securitygroup.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group" "bastion-securitygroup" {
  name = "terraform security group"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id      = "${var.vpc_id}"

  tags = {
    Name = "bastion-securitygroup"
  }
}
