
/* -------------------------------------------------------------------------- */
/*                          Activate Google services                          */
/* -------------------------------------------------------------------------- */

# Enable serviceusage and cloudresourcemanager first
resource "null_resource" "enable_service_usage_api" {
  provisioner "local-exec" {
    command = "gcloud services enable serviceusage.googleapis.com cloudresourcemanager.googleapis.com --project ${var.project_id}"
  }
}

# Wait for the new configuration to propagate
resource "time_sleep" "wait_project_init" {
  create_duration = "60s"

  depends_on = [null_resource.enable_service_usage_api]
}

# Activate Google services
resource "google_project_service" "enabled_services" {
  for_each                   = toset(var.services)
  service                    = "${each.key}.googleapis.com"
  disable_on_destroy         = false
  disable_dependent_services = true

  depends_on = [time_sleep.wait_project_init]
}


/* -------------------------------------------------------------------------- */
/*                          service account IAM roles                         */
/* -------------------------------------------------------------------------- */

# Fetch existing service account
data "google_service_account" "existing_service_account" {
  account_id = var.service_account_name
}


# IAM role assignments for an existing service account
resource "google_project_iam_member" "existing_service_account_iam_roles" {
  for_each = toset(var.service_account_roles)
  project  = var.project_id
  role     = "roles/${each.value}"
  member   = "serviceAccount:${data.google_service_account.existing_service_account.email}"

  depends_on = [google_project_service.enabled_services]
}

# IAM role assignments for Cloud Build service account with specific roles
resource "google_project_iam_member" "cloud_build_service_account_iam_roles" {
  for_each = toset(var.cloud_build_service_account_roles)
  project  = var.project_id
  role     = "roles/${each.value}"
  member   = "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
}



/* -------------------------------------------------------------------------- */
/*                                 VPC Network                                */
/* -------------------------------------------------------------------------- */



module "vpc" {
  source = "../modules/vpc"

  project_id      = var.project_id
  network_name    = var.network_name
  subnetwork_name = var.subnetwork_name
  region          = var.region
  ip_cidr_range   = var.ip_cidr_range

  depends_on = [
    google_project_service.enabled_services,
    google_project_iam_member.existing_service_account_iam_roles
  ]
}

/* -------------------------------------------------------------------------- */
/*                               Secret Manager                               */
/* -------------------------------------------------------------------------- */

module "secret_manager" {
  source = "../modules/secret_manager"

  db_user             = var.db_user
  db_password         = var.db_password
  db_name             = var.db_name
  db_port             = var.db_port
  github_token        = var.github_token
  openai_api_key      = var.openai_api_key
  openai_organization = var.openai_organization

  secret_key_access_api    = var.secret_key_access_api
  first_superuser          = var.first_superuser
  first_superuser_password = var.first_superuser_password



  depends_on = [
    google_project_service.enabled_services,
    google_project_iam_member.existing_service_account_iam_roles
  ]
}


/* -------------------------------------------------------------------------- */
/*                                  Cloud SQL                                 */
/* -------------------------------------------------------------------------- */


module "cloud_sql" {
  source = "../modules/cloud_sql"

  project_id       = var.project_id
  region           = var.region
  zone             = var.zone
  db_instance_name = var.db_instance_name
  db_version       = var.db_version
  db_tier          = var.db_tier
  network_id       = module.vpc.network_id


  depends_on = [
    module.vpc,
    module.secret_manager
  ]
}

/* -------------------------------------------------------------------------- */
/*                                    Redis                                   */
/* -------------------------------------------------------------------------- */


module "redis" {
  source = "../modules/redis"

  project_id = var.project_id
  region     = var.region

  depends_on = [
    module.vpc,
    google_project_service.enabled_services,
    google_project_iam_member.existing_service_account_iam_roles
  ]

}


/* -------------------------------------------------------------------------- */
/*                                 Cloud Build                                */
/* -------------------------------------------------------------------------- */


module "cloud_build" {
  source                 = "../modules/cloud_build"
  project_id             = var.project_id
  project_number         = var.project_number
  repo_name              = var.repo_name
  branch                 = var.branch
  github_installation_id = var.github_installation_id
  region                 = var.region
  github_remote_uri      = var.github_remote_uri

  depends_on = [
    module.vpc,
    module.secret_manager,
    google_project_service.enabled_services,
    google_project_iam_member.cloud_build_service_account_iam_roles
  ]
}

/* -------------------------------------------------------------------------- */
/*                                  Cloud Run                                 */
/* -------------------------------------------------------------------------- */


module "cloud_run" {
  source = "../modules/cloud_run"

  project_id                = var.project_id
  region                    = var.region
  network_id                = module.vpc.network_id
  subnetwork_id             = module.vpc.subnetwork_id
  cloud_sql_connection_name = module.cloud_sql.connection_name
  db_instance_ip_address    = module.cloud_sql.instance_ip_address

  repo_name = var.repo_name


  depends_on = [
    module.vpc,
    module.secret_manager,
    module.cloud_sql,
    module.redis,
    module.cloud_build
  ]
}
