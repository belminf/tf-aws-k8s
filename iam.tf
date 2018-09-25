resource "aws_iam_instance_profile" "k8s" {
  name = "k8s"
  role = "${aws_iam_role.k8s.name}"
}

resource "aws_iam_role" "k8s" {
  name               = "k8s"
  assume_role_policy = "${data.aws_iam_policy_document.k8s-assume.json}"
}


data "aws_iam_policy_document" "k8s-assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_policy" "k8s" {
  name   = "k8s"
  policy = "${data.aws_iam_policy_document.k8s-policy.json}"
}

data "aws_iam_policy_document" "k8s-policy" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "elasticloadbalancing:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "route53:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "ecr:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy_attachment" "k8s" {
  name       = "k8s"
  roles      = ["${aws_iam_role.k8s.name}"]
  policy_arn = "${aws_iam_policy.k8s.arn}"
}
