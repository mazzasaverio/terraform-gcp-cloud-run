output "service_url" {
  value = google_cloud_run_v2_service.pdf_processor_service.uri
}
