terraform {
  required_version = ">= 1.3.7, < 2.0.0"

  required_providers {
    google = ">= 4.52.0, != 4.53.0, < 5.0.0"
    random = ">= 3.4.3, < 4.0.0"
  }
}
