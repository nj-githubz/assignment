# Define bastion inside the public subnet
resource "aws_instance" "bastion" {
  ami                         = "${var.region_ami_map["${var.awsregion}"]}"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_name}"
  subnet_id                   = "${var.subnet_id_public[1]}"
  vpc_security_group_ids      = ["${var.bastion-securitygroup.id}"]
  associate_public_ip_address = true
  source_dest_check           = false

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("${path.module}/${var.pemfile}")}"
    host        = "${aws_instance.bastion.public_ip}"
    agent       = "false"
  }

  provisioner "file" {
    source      = "/tmp/config"
    destination = "/home/ubuntu/config"
  }

  provisioner "file" {
    source      = "/tmp/configmap.yml"
    destination = "/home/ubuntu/configmap.yml"
  }
  depends_on = ["local_file.kubeconfig", "local_file.configmap"]

  provisioner "file" {
    source      = "${path.module}/userdata.sh"
    destination = "/tmp/userdata.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/userdata.sh",
      "sudo /tmp/userdata.sh",
    ]
  }

  tags = {
    Name = "Bastion Host"
  }
}

resource "local_file" "kubeconfig" {
  content  = "${data.template_file.kubeconfig.rendered}"
  filename = "/tmp/config"
}

data "template_file" "kubeconfig" {
  template = "${file("${path.module}/templates/kubeconfig.tpl")}"

  vars = {
    endpoint            = "${var.endpoint}"
    cluster_auth_base64 = "${var.certificate_authority}"
    cluster-name        = "${var.cluster-name}"
  }
}

resource "local_file" "configmap" {
  content  = "${data.template_file.configmap.rendered}"
  filename = "/tmp/configmap.yml"
}

data "template_file" "configmap" {
  template = "${file("${path.module}/templates/configmap.tpl")}"

  vars = {
    eks-cluster-node-role = "${var.eks-cluster-node-role}"
  }
}
