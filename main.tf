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

# Fetch existing service account
data "google_service_account" "existing_service_account" {
  account_id = var.gcp_service_account_name
}

# Activate Google services
resource "google_project_service" "enabled_services" {
  for_each           = toset(var.gcp_services)
  service            = "${each.key}.googleapis.com"
  disable_on_destroy = false
}


# IAM role assignments for an existing service account
resource "google_project_iam_member" "existing_service_account_iam_roles" {
  for_each = toset(var.gcp_existing_service_account_roles)
  project  = var.gcp_project_id
  role     = "roles/${each.value}"
  member   = "serviceAccount:${data.google_service_account.existing_service_account.email}"
}

# IAM role assignments for Cloud Build service account with specific roles
resource "google_project_iam_member" "cloud_build_service_account_iam_roles" {
  for_each = toset(var.gcp_cloud_build_service_account_roles)
  project  = var.gcp_project_id
  role     = "roles/${each.value}"
  member   = "serviceAccount:${var.gcp_project_number}@cloudbuild.gserviceaccount.com"
}



/* -------------------------- Network and Firewall -------------------------- */



module "network" {
  source = "./modules/network"

  gcp_project_id   = var.gcp_project_id
  gcp_network_name = var.gcp_network_name
  gcp_region       = var.gcp_region

  depends_on = [
    google_project_service.enabled_services,
    google_project_iam_member.existing_service_account_iam_roles
  ]
}

module "firewall" {
  source                        = "./modules/firewall"
  gcp_network_name              = module.network.network_id
  internet_access_source_ranges = var.internet_access_source_ranges
  internal_traffic_source_range = var.internal_traffic_source_range
  cloud_sql_proxy_source_range  = var.cloud_sql_proxy_source_range


  depends_on = [
    module.network
  ]
}


module "secret_manager" {
  source = "./modules/secret_manager"

  gcp_db_user             = var.gcp_db_user
  gcp_db_password         = var.gcp_db_password
  gcp_db_name             = var.gcp_db_name
  gcp_db_port             = var.gcp_db_port
  gcp_instance_name       = var.gcp_instance_name
  instance_ssh_public_key = var.instance_ssh_public_key
  github_token            = var.github_token
}



module "cloud_sql" {
  source = "./modules/cloud_sql"

  gcp_project_id               = var.gcp_project_id
  gcp_db_instance_name         = var.gcp_db_instance_name
  gcp_region                   = var.gcp_region
  gcp_db_version               = var.gcp_db_version
  gcp_service_account_email    = data.google_service_account.existing_service_account.email
  network_id                   = module.network.network_id
  cloud_sql_proxy_source_range = var.cloud_sql_proxy_source_range

  depends_on = [
    module.network,
    module.secret_manager
  ]
}


module "cloud_build" {
  source                     = "./modules/cloud_build"
  gcp_project_id             = var.gcp_project_id
  gcp_project_number         = var.gcp_project_number
  repo_name                  = var.repo_name
  branch                     = var.branch
  github_gcp_installation_id = var.github_gcp_installation_id
  gcp_region                 = var.gcp_region
  github_remote_uri          = var.github_remote_uri

  depends_on = [
    module.network,
    module.secret_manager
  ]
}

module "storage" {
  source                = "./modules/storage"
  region                = var.gcp_region
  gcp_project_id        = var.gcp_project_id
  gcp_bucket_name       = var.gcp_bucket_name
  gcp_pubsub_topic_name = var.gcp_pubsub_topic_name
}


module "compute_instance" {
  source = "./modules/compute_instance"

  gcp_project_id            = var.gcp_project_id
  gcp_instance_name         = var.gcp_instance_name
  gcp_instance_type         = var.gcp_instance_type
  gcp_instance_zone         = var.gcp_instance_zone
  gcp_instance_image        = var.gcp_instance_image
  gcp_instance_tags         = var.gcp_instance_tags
  gcp_service_account_email = data.google_service_account.existing_service_account.email
  gcp_db_user               = var.gcp_db_user
  gcp_db_password           = var.gcp_db_password
  gcp_db_name               = var.gcp_db_name
  network_id                = module.network.network_id
  subnetwork_id             = module.network.subnetwork_id
  db_instance_ip_address    = module.cloud_sql.instance_ip_address
  instance_ssh_public_key   = var.instance_ssh_public_key



  depends_on = [
    module.firewall,
    module.cloud_sql,
    module.secret_manager
  ]
}



module "cloud_run" {
  source = "./modules/cloud_run"

  gcp_project_id             = var.gcp_project_id
  gcp_region                 = var.gcp_region
  pdf_uploaded_topic_id      = var.gcp_pubsub_topic_name
  network_id                 = module.network.network_id
  subnetwork_id              = module.network.subnetwork_id
  gcp_db_instance_ip_address = module.cloud_sql.instance_ip_address
  gcp_bucket_name            = module.storage.bucket_name
  gcp_storage_option         = var.gcp_storage_option

  depends_on = [
    module.network,
    module.secret_manager
  ]
}


module "pubsub" {
  source                    = "./modules/pubsub"
  cloud_run_service_url     = module.cloud_run.service_url
  gcp_pubsub_topic_name     = var.gcp_pubsub_topic_name
  gcp_project_id            = var.gcp_project_id
  gcp_service_account_email = data.google_service_account.existing_service_account.email

}


