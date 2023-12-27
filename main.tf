
/* -------------------------------------------------------------------------- */
/*                                  PROVIDERS                                 */
/* -------------------------------------------------------------------------- */

provider "google" {
  credentials = file(var.gcp_credentials_file)
  project     = var.gcp_project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
}

module "vpc_peerings" {
  source           = "./modules/vpc_peerings"
  gcp_project_id   = var.gcp_project_id
  gcp_network_name = var.gcp_network_name
}


module "storage" {
  source                = "./modules/storage"
  region                = var.gcp_region
  gcp_project_id        = var.gcp_project_id
  gcp_bucket_name       = var.gcp_bucket_name
  gcp_pubsub_topic_name = var.gcp_pubsub_topic_name

}


module "cloud_sql" {
  source                    = "./modules/cloud_sql"
  gcp_network_name          = var.gcp_network_name
  gcp_db_instance_name      = var.gcp_db_instance_name
  gcp_db_version            = var.gcp_db_version
  gcp_region                = var.gcp_region
  gcp_db_istance_password   = var.gcp_db_istance_password
  gcp_db_tier               = var.gcp_db_tier
  gcp_project_id            = var.gcp_project_id
  gcp_service_account_email = var.gcp_service_account_email
  gcp_db_user               = var.gcp_db_user
  gcp_db_password           = var.gcp_db_password
  gcp_db_name               = var.gcp_db_name


}


module "cloud_run" {
  source = "./modules/cloud_run"

  gcp_project_id       = var.gcp_project_id
  gcp_region           = var.gcp_region
  gcp_db_instance_name = var.gcp_db_instance_name
  gcp_db_name          = var.gcp_db_name
  gcp_db_user          = var.gcp_db_user
  gcp_db_password      = var.gcp_db_password
  gcp_network_name     = var.gcp_network_name
  gcp_db_host          = var.gcp_db_host
}

module "pubsub" {
  source                    = "./modules/pubsub"
  cloud_run_service_url     = module.cloud_run.service_url
  gcp_pubsub_topic_name     = var.gcp_pubsub_topic_name
  gcp_project_id            = var.gcp_project_id
  gcp_service_account_email = var.gcp_service_account_email

}
