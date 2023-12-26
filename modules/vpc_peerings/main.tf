resource "google_compute_global_address" "google_managed_services_default" {
  name          = "google-managed-services-default-v2"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.gcp_network_name
  project       = var.gcp_project_id
  description   = "peering range for Google"
}

# Existing google_service_networking_connection resource
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.gcp_network_name
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.google_managed_services_default.name]
}
