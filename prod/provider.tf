terraform {
  required_version = ">= 1.3"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "< 6"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "< 6"
    }
  }

  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-cloud-run/v0.10.0"
  }

  provider_meta "google-beta" {
    module_name = "blueprints/terraform/terraform-google-cloud-run/v0.10.0"
  }
}
provider "google" {
  credentials = file(var.path_credentials_json_file)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

provider "google-beta" {
  credentials = file(var.path_credentials_json_file)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}
