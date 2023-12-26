
# ------------------------------- GOOGLE CLOUD ------------------------------- #

variable "gcp_project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "gcp_credentials_file" {
  description = "The path to the Google Cloud credentials file."
  type        = string
}


variable "gcp_region" {
  description = "The GCP region."
  type        = string
}

variable "gcp_zone" {
  description = "The GCP zone."
  type        = string
}

variable "gcp_service_account_email" {
  description = "Service account email to invoke the Cloud Run service"
  type        = string
}

variable "gcp_network_name" {
  description = "The GCP network name."
  type        = string
}

# ------------------------------- GCP SQL CLOUD ------------------------------- #

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

variable "gcp_db_instance_name" {
  description = "The name of the db instance."
  type        = string
}

variable "gcp_db_tier" {
  description = "The tier of the db instance."
  type        = string
}

variable "gcp_db_version" {
  description = "The version of the db instance."
  type        = string
}



variable "gcp_db_istance_password" {
  description = "The password for the default user."
  default     = "my-cloud-sql-instance-password"
}






