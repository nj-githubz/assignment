#Public Subnet
resource "aws_subnet" "eks-cluster-subnet-public" {
  count                   = "${length(var.public-cidr)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block              = "${var.public-cidr[count.index]}"
  vpc_id                  = "${var.vpc_id}"
  map_public_ip_on_launch = true
  tags = "${
    map(
      "Name", "public-eks",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

#IGW for internet
resource "aws_internet_gateway" "eks-cluster-igw" {
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "eks-cluster-igw"
  }
}

#Attaching internet gateway to RouteTable
resource "aws_route_table" "eks-cluster-routetable-public" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.eks-cluster-igw.id}"
  }

  tags = {
    Name = "eks-cluster-routetable-public"
  }

}

#Associating the Public RouteTable to Public Subnet
resource "aws_route_table_association" "routetable-association-public" {
  count          = "${length(var.public-cidr)}"
  subnet_id      = "${aws_subnet.eks-cluster-subnet-public.*.id[count.index]}"
  route_table_id = "${aws_route_table.eks-cluster-routetable-public.id}"
}


## Private Subnet
resource "aws_subnet" "eks-cluster-subnet-private" {
  count             = "${length(var.private-cidr)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${var.private-cidr[count.index]}"
  vpc_id            = "${var.vpc_id}"

  tags = "${
    map(
      "Name", "private-eks",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

# EIP To be associate with NATGateway
resource "aws_eip" "nat" {
  vpc   = true
  count = "${length(var.private-cidr)}"
}

#Natgate way in Public Subnet for internet access to Private Subnet
resource "aws_nat_gateway" "eks-cluster-natgw" {
  count         = "${length(var.private-cidr)}"
  allocation_id = "${aws_eip.nat.*.id[count.index]}"
  subnet_id     = "${aws_subnet.eks-cluster-subnet-public.*.id[count.index]}"
  depends_on    = ["aws_internet_gateway.eks-cluster-igw"]
  tags = {
    Name = "eks-cluster-natgw"
  }
}

resource "aws_route_table" "eks-cluster-routetable-private" {
  vpc_id = "${var.vpc_id}"
  count  = "${length(var.private-cidr)}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.eks-cluster-natgw[count.index].id}"
  }

  tags = {
    Name = "eks-cluster-routetable-private"
  }
}

resource "aws_route_table_association" "privatesubnet_rt_table_assocation" {
  count          = "${length(var.private-cidr)}"
  subnet_id      = "${aws_subnet.eks-cluster-subnet-private.*.id[count.index]}"
  route_table_id = "${aws_route_table.eks-cluster-routetable-private.*.id[count.index]}"
}
