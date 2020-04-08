# Define bastion inside the public subnet
#resource "aws_instance" "jenkins" {
#  #count = 2
#  ami                         = "${var.ami}"
#  instance_type               = "t2.micro"
#  key_name                    = "${var.key_name}"
#  subnet_id                   = "${var.subnet_id[0]}"
#  vpc_security_group_ids      = ["${var.eks-cluster-node.id}"]
#  associate_public_ip_address = false
#  source_dest_check           = false

#  provisioner "file" {
#    source      = "${path.module}/userdata.sh"
#    destination = "/tmp/userdata_jenkins.sh"
#  }

#  provisioner "remote-exec" {
#    inline = [
#      "sudo chmod +x /tmp/userdata_jenkins.sh",
#      "sudo /tmp/userdata_jenkins.sh"
#    ]
#  }

#  tags = {
#    Name = "Jenkins Server"
#  }
#}




