/* ------------------------------ GCP Foundation----------------------------- */

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}
variable "project_number" {
  description = "The GCP project number."
  type        = string
}

variable "path_credentials_json_file" {
  description = "The path to the Google Cloud Service Account credentials file."
  type        = string
}

variable "region" {
  description = "The region where the resources will be created."
  type        = string
}

variable "zone" {
  description = "The zone where the resources will be created."
  type        = string
}

variable "service_account_name" {
  description = "The name of the service account."
  type        = string
}
