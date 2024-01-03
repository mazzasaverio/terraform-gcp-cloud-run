resource "google_cloud_run_v2_service" "pdf_processor_service" {
  name         = "pdf-processor-service"
  location     = var.gcp_region
  launch_stage = "BETA" // Add this line

  template {
    containers {
      image = "gcr.io/your-project-id/your-service-image"

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

resource "google_eventarc_trigger" "pdf_uploaded_trigger" {
  name     = "pdf-uploaded-trigger"
  location = var.gcp_region
  destination {
    cloud_run_service {
      service = google_cloud_run_v2_service.pdf_processor_service.name
      region  = var.gcp_region
    }
  }
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.storage.object.v1.finalized"
  }
  transport {
    pubsub {
      topic = var.pdf_uploaded_topic_id
    }
  }
}
