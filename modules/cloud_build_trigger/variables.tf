variable "gcp_project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "repo_name" {
  description = "The name of the repository to create the trigger for the Cloud Build."
  type        = string
}

variable "owner" {
  description = "The owner of the repository to create the trigger for the Cloud Build."
  type        = string
}

variable "branch" {
  description = "The branch of the repository to create the trigger for the Cloud Build."
  type        = string
}
