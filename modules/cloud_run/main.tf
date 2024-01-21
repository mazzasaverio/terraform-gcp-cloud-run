data "google_secret_manager_secret_version" "db_user" {
  secret  = "DB_USER_SECRET"
  project = var.gcp_project_id
  version = "latest"
}

data "google_secret_manager_secret_version" "db_pass" {
  secret  = "DB_PASS_SECRET"
  project = var.gcp_project_id
  version = "latest"
}



data "google_secret_manager_secret_version" "db_name" {
  secret  = "DB_NAME_SECRET"
  project = var.gcp_project_id
  version = "latest"
}





resource "google_cloud_run_v2_service" "pdf_processor_service" {
  name         = "pdf-processor-service"
  location     = var.gcp_region
  launch_stage = "BETA"
  ingress      = "INGRESS_TRAFFIC_INTERNAL_ONLY"


  traffic {
    percent = 100
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }

  template {
    containers {
      image = "gcr.io/${var.gcp_project_id}/your-service-image:latest"

      resources {
        cpu_idle          = true
        startup_cpu_boost = true
        limits = {
          cpu    = "2"
          memory = "4Gi"
        }
      }

      env {
        name  = "DB_USER"
        value = data.google_secret_manager_secret_version.db_user.secret_data
      }
      env {
        name  = "DB_PASS"
        value = data.google_secret_manager_secret_version.db_pass.secret_data
      }
      env {
        name  = "DB_NAME"
        value = data.google_secret_manager_secret_version.db_name.secret_data
      }
      env {
        name  = "DB_HOST"
        value = var.gcp_db_instance_ip_address
      }
      env {
        name  = "STORAGE_OPTION"
        value = var.gcp_storage_option
      }
      env {
        name  = "GCS_BUCKET_NAME"
        value = var.gcp_bucket_name
      }
    }



    vpc_access {
      #egress = "ALL_TRAFFIC"
      egress = "PRIVATE_RANGES_ONLY"
      network_interfaces {
        network    = var.network_id
        subnetwork = var.subnetwork_id
        tags       = ["cloud-run-service"]
      }
    }
  }
}
