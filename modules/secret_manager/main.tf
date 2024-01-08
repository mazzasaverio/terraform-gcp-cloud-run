resource "google_secret_manager_secret" "github_token_secret" {
  project   = var.gcp_project_id
  secret_id = "github_pat"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "github_pat_version" {
  secret      = google_secret_manager_secret.github_token_secret.id
  secret_data = var.github_token
}

data "google_iam_policy" "serviceagent_secretAccessor" {
  binding {
    role    = "roles/secretmanager.secretAccessor"
    members = ["serviceAccount:service-${var.gcp_project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"]
  }
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  project     = google_secret_manager_secret.github_token_secret.project
  secret_id   = google_secret_manager_secret.github_token_secret.secret_id
  policy_data = data.google_iam_policy.serviceagent_secretAccessor.policy_data
}
