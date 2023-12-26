resource "google_sql_database_instance" "instance" {
  name             = var.gcp_db_instance_name
  database_version = var.gcp_db_version
  region           = var.gcp_region

  settings {
    tier = "db-custom-1-4096" # Adjust as needed

    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/${var.gcp_project_id}/global/networks/${var.gcp_network_name}"
      require_ssl     = true
    }
  }

  root_password = var.gcp_db_istance_password
}
