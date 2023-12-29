resource "google_compute_network" "peering_network" {
  project                 = var.gcp_project_id
  name                    = var.gcp_network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "peering_subnetwork" {
  name          = "peering-subnetwork"
  network       = google_compute_network.peering_network.id
  ip_cidr_range = "10.1.0.0/24"
  region        = var.gcp_region
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.peering_network.id
}

resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.peering_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_compute_network_peering_routes_config" "peering_routes" {
  peering              = google_service_networking_connection.default.peering
  network              = google_compute_network.peering_network.name
  import_custom_routes = true
  export_custom_routes = true
}

