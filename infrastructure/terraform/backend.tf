terraform {
  backend "s3" {
    bucket = "tf-config-state"
    key    = "dev"
    region = "eu-west-2"
  }
}
