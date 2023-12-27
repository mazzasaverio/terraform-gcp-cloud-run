
resource "google_cloud_run_v2_service" "run_sql_service" {
  name     = "run-sql"
  location = var.gcp_region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "gcr.io/${var.gcp_project_id}/run-sql"

      env {
        name  = "DB_NAME"
        value = var.gcp_db_name
      }
      env {
        name  = "DB_USER"
        value = var.gcp_db_user
      }
      env {
        name  = "DB_PASS"
        value = var.gcp_db_password
      }
      env {
        name  = "INSTANCE_CONNECTION_NAME"
        value = "${var.gcp_project_id}:${var.gcp_region}:${var.gcp_db_instance_name}"
      }
      env {
        name  = "DB_PORT"
        value = "5432"
      }
      env {
        name  = "INSTANCE_HOST"
        value = var.gcp_db_host
      }
      env {
        name  = "DB_ROOT_CERT"
        value = "certs/server-ca.pem"
      }
      env {
        name  = "DB_CERT"
        value = "certs/client-cert.pem"
      }
      env {
        name  = "DB_KEY"
        value = "certs/client-key.pem"
      }
      env {
        name  = "PRIVATE_IP"
        value = "TRUE"
      }

      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }
    }

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = ["${var.gcp_project_id}:${var.gcp_region}:${var.gcp_db_instance_name}"]
      }
    }

    vpc_access {
      connector = google_vpc_access_connector.quickstart_connector.id
      egress    = "ALL_TRAFFIC"
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

resource "google_vpc_access_connector" "quickstart_connector" {
  name          = "quickstart-connector"
  network       = var.gcp_network_name
  ip_cidr_range = "10.8.0.0/28"
  machine_type  = "f1-micro"
  min_instances = 2
  max_instances = 3
  region        = var.gcp_region
  project       = var.gcp_project_id
}
