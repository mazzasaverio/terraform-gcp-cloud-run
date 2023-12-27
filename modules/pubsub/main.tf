resource "google_pubsub_topic" "pdf_topic" {
  name = var.gcp_pubsub_topic_name
}

resource "google_pubsub_subscription" "pdf_subscription" {
  name  = "pdf-upload-subscription-v3"
  topic = google_pubsub_topic.pdf_topic.name


  push_config {
    push_endpoint = var.cloud_run_service_url
    oidc_token {
      service_account_email = var.gcp_service_account_email
    }

  }

  retry_policy {
    minimum_backoff = "0s"
    maximum_backoff = "0s"
  }
}
