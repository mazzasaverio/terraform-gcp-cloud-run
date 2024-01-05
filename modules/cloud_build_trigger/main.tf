
resource "google_cloudbuild_trigger" "github_master_push_trigger" {
  project     = var.gcp_project_id
  name        = "name-of-the-trigger"
  description = "Description of the trigger"
  filename    = "cloudbuild.yaml" # or the path to your build config file
  github {
    owner = var.owner
    name  = var.repo_name

    push {
      branch = var.branch
    }
  }
}
