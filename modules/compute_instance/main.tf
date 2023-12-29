

resource "google_compute_instance" "app_instance" {
  name         = var.gcp_instance_name
  machine_type = var.gcp_instance_type
  zone         = var.gcp_instance_zone

  boot_disk {
    initialize_params {
      image = var.gcp_instance_image
    }
  }

  network_interface {
    network    = var.network_id
    subnetwork = var.subnetwork_id
    access_config {}
  }

  metadata = {
    "db-user"                 = var.gcp_db_user
    "db-pass"                 = var.gcp_db_password
    "db-name"                 = var.gcp_db_name
    "db-host"                 = var.db_instance_ip_address
    "instance-ssh-user"       = var.instance_ssh_user
    "instance-ssh-public-key" = var.instance_ssh_public_key
  }

  metadata_startup_script = file("${path.module}/startup-script.sh")

  service_account {
    email  = var.gcp_service_account_email
    scopes = ["cloud-platform"]
  }

  tags = var.gcp_instance_tags

  allow_stopping_for_update = true
}
