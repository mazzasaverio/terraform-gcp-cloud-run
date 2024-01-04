terraform {
  required_providers {
    google = {
      source = "hashicorp/google"

    }
    google-beta = {
      source = "hashicorp/google-beta"

    }
  }
}

provider "google" {
  credentials = file(var.gcp_credentials_file)
  project     = var.gcp_project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
}

provider "google-beta" {
  credentials = file(var.gcp_credentials_file)
  project     = var.gcp_project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
}


module "network" {
  source = "./modules/network"

  gcp_project_id   = var.gcp_project_id
  gcp_network_name = var.gcp_network_name
  gcp_region       = var.gcp_region
}

module "firewall" {
  source                        = "./modules/firewall"
  network_name                  = module.network.network_id
  internal_traffic_source_range = "10.1.0.0/24"
  internet_access_source_ranges = ["0.0.0.0/0"]

  depends_on = [
    module.network
  ]
}


module "cloud_sql" {
  source = "./modules/cloud_sql"

  gcp_project_id            = var.gcp_project_id
  gcp_db_instance_name      = var.gcp_db_instance_name
  gcp_region                = var.gcp_region
  gcp_db_version            = var.gcp_db_version
  gcp_db_user               = var.gcp_db_user
  gcp_db_password           = var.gcp_db_password
  gcp_db_name               = var.gcp_db_name
  gcp_service_account_email = var.gcp_service_account_email
  network_id                = module.network.network_id

  depends_on = [
    module.network
  ]
}

module "compute_instance" {
  source = "./modules/compute_instance"

  gcp_instance_name         = var.gcp_instance_name
  gcp_instance_type         = var.gcp_instance_type
  gcp_instance_zone         = var.gcp_instance_zone
  gcp_instance_image        = var.gcp_instance_image
  gcp_instance_tags         = var.gcp_instance_tags
  gcp_service_account_email = var.gcp_service_account_email
  gcp_db_user               = var.gcp_db_user
  gcp_db_password           = var.gcp_db_password
  gcp_db_name               = var.gcp_db_name
  network_id                = module.network.network_id
  subnetwork_id             = module.network.subnetwork_id
  db_instance_ip_address    = module.cloud_sql.instance_ip_address
  instance_ssh_public_key   = var.instance_ssh_public_key

  depends_on = [
    module.firewall,
    module.cloud_sql
  ]
}

module "storage" {
  source                = "./modules/storage"
  region                = var.gcp_region
  gcp_project_id        = var.gcp_project_id
  gcp_bucket_name       = var.gcp_bucket_name
  gcp_pubsub_topic_name = var.gcp_pubsub_topic_name
}

module "cloud_run" {
  source = "./modules/cloud_run"

  gcp_project_id        = var.gcp_project_id
  gcp_region            = var.gcp_region
  gcp_db_user           = var.gcp_db_user
  gcp_db_password       = var.gcp_db_password
  gcp_db_name           = var.gcp_db_name
  pdf_uploaded_topic_id = var.gcp_pubsub_topic_name

  network_id             = module.network.network_id
  subnetwork_id          = module.network.subnetwork_id
  db_instance_ip_address = module.cloud_sql.instance_ip_address
  gcp_bucket_name        = module.storage.bucket_name
}



module "pubsub" {
  source                    = "./modules/pubsub"
  cloud_run_service_url     = module.cloud_run.service_url
  gcp_pubsub_topic_name     = var.gcp_pubsub_topic_name
  gcp_project_id            = var.gcp_project_id
  gcp_service_account_email = var.gcp_service_account_email

}


module "cloud_build_trigger" {
  source         = "./modules/cloud_build_trigger"
  gcp_project_id = var.gcp_project_id
  repo_name      = var.repo_name
}



