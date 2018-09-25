resource "aws_security_group" "internal" {
  name        = "k8s_internal"
  description = "Internal k8s"
  vpc_id      = "${aws_vpc.vpc.id}"
  ingress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    self      = true
  }
  tags {
    Name    = "k8s_internal"
    Project = "k8s"
  }
}

resource "aws_security_group" "egress" {
  name        = "k8s_egress"
  description = "Egress to Internet"
  vpc_id      = "${aws_vpc.vpc.id}"
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name    = "k8s_egress"
    Project = "k8s"
  }
}

resource "aws_security_group" "ssh" {
  name        = "k8s_ssh"
  description = "SSH"
  vpc_id      = "${aws_vpc.vpc.id}"
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name    = "k8s_ssh"
    Project = "k8s"
  }
}

resource "aws_security_group" "https" {
  name        = "k8s_https"
  description = "HTTPS"
  vpc_id      = "${aws_vpc.vpc.id}"
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name    = "k8s_icmp"
    Project = "k8s"
  }
}

resource "aws_security_group" "icmp" {
  name        = "k8s_icmp"
  description = "ICMP in SG"
  vpc_id      = "${aws_vpc.vpc.id}"
  ingress {
    protocol        = "icmp"
    from_port       = -1
    to_port         = -1
    self            = true
    security_groups = []
  }
  egress {
    protocol        = "icmp"
    from_port       = -1
    to_port         = -1
    self            = true
    security_groups = []
  }
  tags {
    Name    = "k8s_icmp"
    Project = "k8s"
  }
}
