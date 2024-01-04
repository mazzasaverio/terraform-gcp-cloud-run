resource "google_pubsub_topic" "pdf_topic" {
  name = var.gcp_pubsub_topic_name
}

resource "google_pubsub_topic" "dead_letter_topic" {
  name = "${var.gcp_pubsub_topic_name}-dead-letter"
}

resource "google_pubsub_subscription" "pdf_subscription" {
  name  = "pdf-upload-subscription-v3"
  topic = google_pubsub_topic.pdf_topic.name

  push_config {
    push_endpoint = "${var.cloud_run_service_url}/pubsub-handler"
    oidc_token {
      service_account_email = var.gcp_service_account_email
    }
  }

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.dead_letter_topic.id
    max_delivery_attempts = 5
  }

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "20s"
  }
}
