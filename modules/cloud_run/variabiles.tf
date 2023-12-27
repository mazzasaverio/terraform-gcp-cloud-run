# Cloud Run Module Variables

variable "gcp_project_id" {
  description = "The Google Cloud Project ID."
  type        = string
}

variable "gcp_region" {
  description = "The region where the Cloud Run service will be deployed."
  type        = string
}

variable "gcp_db_instance_name" {
  description = "The name of the Cloud SQL instance."
  type        = string
}

variable "gcp_db_name" {
  description = "The name of the database within the Cloud SQL instance."
  type        = string
}

variable "gcp_db_user" {
  description = "The username for the database."
  type        = string
}

variable "gcp_db_password" {
  description = "The password for the database user."
  type        = string
}

variable "gcp_network_name" {
  description = "The name of the VPC network to which the Cloud Run service will connect."
  type        = string
}

variable "gcp_db_host" {
  description = "The host of the Cloud SQL instance."
  type        = string
}
# Add any other variables specific to your Cloud Run configuration here
