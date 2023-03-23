# Terraform docs re: configuring back end: https://www.terraform.io/docs/backends/types/gcs.html
terraform {
  backend "gcs" {
    # These arguments will be passed as backend-config variables in the terraform init. See cloudbuild.yaml.
    # prefix  = "terraform/state"
    # bucket  = "" 
    # project = ""
  }
}