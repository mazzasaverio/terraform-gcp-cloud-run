output "service_url" {
  value = google_cloud_run_v2_service.run_sql_service.uri
}
