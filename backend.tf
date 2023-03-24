# Terraform docs re: configuring back end: https://www.terraform.io/docs/backends/types/gcs.html
terraform {
  backend "gcs" {
    # prefix  = "terraform/state"
    bucket = "gcp-service-hardening-tfstate"
  }
}
