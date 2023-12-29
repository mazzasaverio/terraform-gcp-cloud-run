resource "google_compute_firewall" "internal_traffic" {
  name    = "allow-internal-traffic"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [var.internal_traffic_source_range]
}

resource "google_compute_firewall" "internet_access" {
  name    = "allow-ssh-icmp-http"
  network = var.network_name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = var.internet_access_source_ranges
}
