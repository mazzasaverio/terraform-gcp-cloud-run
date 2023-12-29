output "network_id" {
  value = google_compute_network.peering_network.id
}

output "subnetwork_id" {
  value = google_compute_subnetwork.peering_subnetwork.id
}
