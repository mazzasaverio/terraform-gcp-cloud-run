resource "google_sql_database_instance" "instance" {
  name             = var.gcp_db_instance_name
  region           = var.gcp_region
  database_version = var.gcp_db_version
  settings {
    tier = "db-custom-2-7680"
    ip_configuration {
      # ipv4_enabled                                  = "false"
      private_network                               = var.network_id
      enable_private_path_for_google_cloud_services = true

      authorized_networks {
        name  = "my-authorized-network"
        value = "79.21.151.251"
      }

    }

  }
  deletion_protection = false
}



resource "google_sql_user" "user" {
  name     = var.gcp_db_user
  instance = google_sql_database_instance.instance.name
  password = var.gcp_db_password
}

resource "google_sql_database" "db_name" {
  name     = var.gcp_db_name
  instance = google_sql_database_instance.instance.name
}

resource "google_project_iam_member" "cloudsql_client" {
  project = var.gcp_project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${var.gcp_service_account_email}"
}

