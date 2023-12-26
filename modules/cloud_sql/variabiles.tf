

variable "gcp_network_name" {
  description = "The name of the network to create the Cloud SQL instance in."
  default     = "default"
}

variable "gcp_region" {
  description = "The region to create the Cloud SQL instance in."
  default     = "us-central1"
}

variable "gcp_db_istance_password" {
  description = "The password for the default user."
  default     = "my-cloud-sql-instance-password"
}

variable "gcp_db_instance_name" {
  description = "The name of the db instance."
  type        = string
}

variable "gcp_db_tier" {
  description = "The tier of the db instance."
  type        = string
}

variable "gcp_db_version" {
  description = "The database version to use."
  default     = "POSTGRES_15"
}

variable "gcp_project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "gcp_service_account_email" {
  description = "The email of the service account to grant access to the Cloud SQL instance."
  type        = string
}



variable "gcp_db_password" {
  description = "The password for the db user."
  type        = string
}

variable "gcp_db_user" {
  description = "The name of the db user."
  type        = string
}

variable "gcp_db_name" {
  description = "The name of the db."
  type        = string
}
