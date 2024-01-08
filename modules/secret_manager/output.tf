output "github_token_secret_version_id" {
  value = google_secret_manager_secret_version.github_pat_version.id
}
