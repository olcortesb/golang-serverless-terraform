terraform {
  backend "s3" {
    key          = "golang/terraform.tfstate"
    bucket       = "terraform-state-olcb"
    region       = "eu-central-1"
    use_lockfile = true
  }
}
