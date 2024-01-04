
resource "google_cloudbuild_trigger" "github_master_push_trigger" {
  project     = var.gcp_project_id
  name        = "name-of-the-trigger"
  description = "Description of the trigger"
  filename    = "cloudbuild.yaml" # or the path to your build config file
  github {
    owner = "mazzasaverio" # Replace with the GitHub owner name
    name  = "clean-text"   # Replace with the GitHub repo name

    push {
      branch = "master" # This is a regex for the branch
    }
  }
}
