

resource "aws_instance" "master" {
  ami = "${data.aws_ami.ubuntu.id}"

  instance_type = "${var.master_instance_type}"

  subnet_id = "${aws_subnet.public.0.id}"

  vpc_security_group_ids = [
    "${aws_security_group.internal.id}",
    "${aws_security_group.egress.id}",
    "${aws_security_group.ssh.id}",
    "${aws_security_group.icmp.id}",
    "${aws_security_group.https.id}",
  ]

  associate_public_ip_address = true
  source_dest_check           = false

  iam_instance_profile = "${aws_iam_instance_profile.k8s.name}"
  key_name             = "${var.keypair}"
  user_data            = "${data.template_cloudinit_config.master.rendered}"

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  tags {
    Name    = "master"
    Project = "k8s"
  }
}

data "template_file" "master" {
  template = "${file("${path.root}/user_data/master.tpl")}"

  vars {
    kubeadm_token = "${random_string.kubeadm_token1.result}.${random_string.kubeadm_token2.result}"
  }
}

data "template_cloudinit_config" "master" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.master.rendered}"
  }
}

output "master.public_ip" {
  value = "${aws_instance.master.public_ip}"
}
