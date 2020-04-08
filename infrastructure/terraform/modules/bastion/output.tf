output "bastion_ip" {
  value = "${aws_instance.bastion.public_ip}"
}

output "key_name" {
  value = "${var.key_name}"
}
