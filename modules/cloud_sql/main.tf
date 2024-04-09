
data "google_secret_manager_secret_version" "db_user" {
  secret  = "DB_USER"
  project = var.project_id
  version = "latest"
}

data "google_secret_manager_secret_version" "db_pass" {
  secret  = "DB_PASS"
  project = var.project_id
  version = "latest"
}

data "google_secret_manager_secret_version" "db_name" {
  secret  = "DB_NAME"
  project = var.project_id
  version = "latest"
}

/* -------------------------- Instance, user and db ------------------------- */


resource "google_sql_database_instance" "instance" {
  name             = var.db_instance_name
  database_version = var.db_version
  region           = var.region
  root_password    = data.google_secret_manager_secret_version.db_pass.secret_data

  settings {
    tier = var.db_tier
  }

  deletion_protection = false
}

resource "google_sql_user" "user" {
  name     = data.google_secret_manager_secret_version.db_user.secret_data
  instance = google_sql_database_instance.instance.name
  password = data.google_secret_manager_secret_version.db_pass.secret_data
}

resource "google_sql_database" "db_name" {
  name     = data.google_secret_manager_secret_version.db_name.secret_data
  instance = google_sql_database_instance.instance.name
}


/* ------------------------ Save SQL connection name ------------------------ */

resource "google_secret_manager_secret" "connection_name" {
  secret_id = "CONNECTION_CLOUD_SQL_NAME"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "connection_name" {
  secret      = google_secret_manager_secret.connection_name.id
  secret_data = google_sql_database_instance.instance.connection_name
}
