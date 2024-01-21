variable "gcp_region" {
  description = "The region where the Cloud Run service will be deployed."
  type        = string
}



variable "network_id" {
  description = "The ID of the VPC network."
  type        = string
}

variable "subnetwork_id" {
  description = "The ID of the subnetwork."
  type        = string
}

variable "gcp_db_instance_ip_address" {
  description = "The private IP address of the Cloud SQL instance."
  type        = string
}

variable "pdf_uploaded_topic_id" {
  description = "ID of the Pub/Sub topic for uploaded PDFs"
  type        = string
}

variable "gcp_project_id" {
  description = "Project ID"
  type        = string
}

variable "gcp_bucket_name" {
  description = "Name of the GCS bucket"
  type        = string
}

variable "gcp_storage_option" {
  description = "Storage option for the GCS bucket"
  type        = string
}
