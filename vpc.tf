resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags {
    Name    = "k8s"
    Project = "k8s"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.10.0/24"
  tags {
    Name = "k8s_public"
    Project = "k8s"
  }
}

resource "aws_internet_gateway" "igw" {
	vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "public" {
 	vpc_id = "${aws_vpc.vpc.id}"
	route {
  	cidr_block     = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags {
    Name    = "k8s"
    Project = "k8s"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id        = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "private" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.20.0/24"
  tags {
    Name = "k8s_private"
    Project = "k8s"
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id   = "${aws_subnet.public.id}"

}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block         = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.ngw.id}"
  }
  tags {
    Name    = "k8s_private"
    Project = "k8s"
  }
}

resource "aws_route_table_association" "private_subnet_a" {
    subnet_id        = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.private.id}"
}
