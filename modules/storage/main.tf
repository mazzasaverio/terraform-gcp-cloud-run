resource "google_storage_bucket" "bucket" {
  name          = var.gcp_bucket_name
  location      = var.region
  force_destroy = true
}



data "google_storage_project_service_account" "gcs_account" {
  project = var.gcp_project_id
}

resource "google_pubsub_topic_iam_binding" "binding" {
  topic   = "projects/${var.gcp_project_id}/topics/${var.gcp_pubsub_topic_name}"
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}

resource "google_storage_notification" "pdf_notification" {
  bucket         = google_storage_bucket.bucket.name
  event_types    = ["OBJECT_FINALIZE"]
  payload_format = "JSON_API_V1"
  topic          = "projects/${var.gcp_project_id}/topics/${var.gcp_pubsub_topic_name}"
}

