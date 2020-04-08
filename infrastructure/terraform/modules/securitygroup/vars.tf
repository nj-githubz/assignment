variable "vpc_id" {}
variable "subnet_id" {}

variable "external_cidr" {
  default = ["0.0.0.0/0"]
}
