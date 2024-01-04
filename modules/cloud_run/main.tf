resource "google_cloud_run_v2_service" "pdf_processor_service" {
  name         = "pdf-processor-service"
  location     = var.gcp_region
  launch_stage = "BETA" // Add this line

  template {
    containers {
      image = "gcr.io/${var.gcp_project_id}/your-service-image:latest"

      env {
        name  = "DB_USER"
        value = var.gcp_db_user
      }
      env {
        name  = "DB_PASS"
        value = var.gcp_db_password
      }
      env {
        name  = "DB_NAME"
        value = var.gcp_db_name
      }
      env {
        name  = "DB_HOST"
        value = var.db_instance_ip_address
      }
    }



    vpc_access {
      egress = "ALL_TRAFFIC"
      network_interfaces {
        network    = var.network_id
        subnetwork = var.subnetwork_id
        tags       = ["cloud-run-service"]
      }
    }
  }
}
