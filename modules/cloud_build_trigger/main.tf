
// Create the GitHub connection
resource "google_cloudbuildv2_connection" "my_connection" {
  project  = var.gcp_project_id
  location = var.gcp_region
  name     = "github-connection"

  github_config {
    app_installation_id = var.github_gcp_installation_id
    authorizer_credential {
      oauth_token_secret_version = var.github_token_secret_version_id
    }
  }

}

resource "google_cloudbuildv2_repository" "my_repository" {
  project           = var.gcp_project_id
  location          = var.gcp_region
  name              = var.repo_name
  parent_connection = google_cloudbuildv2_connection.my_connection.name
  remote_uri        = var.github_remote_uri
}

resource "google_cloudbuild_trigger" "repo-trigger" {
  location = "us-central1"

  repository_event_config {
    repository = google_cloudbuildv2_repository.my_repository.id
    push {
      branch = var.branch
    }
  }

  filename = "cloudbuild.yaml"
}

