output "repo_url" {
  value = "${module.ecr.repo_url}"
}

output "bastion_ip" {
  value = "${module.bastion.bastion_ip}"
}
