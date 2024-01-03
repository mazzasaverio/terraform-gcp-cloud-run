output "bucket_name" {
  value = google_storage_bucket.bucket.name
}

output "pdf_uploaded_topic_id" {
  value = google_pubsub_topic.pdf_uploaded_topic.id
}
