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

  source_ranges = ["10.1.0.0/24"]
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

  source_ranges = ["0.0.0.0/0"]
}



resource "google_compute_firewall" "cloud_sql_proxy" {
  name    = "allow-cloud-sql-proxy"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["5433", "3307"]
  }

  source_ranges = ["79.21.151.251"]
  target_tags   = ["cloud-sql-proxy"]
}
