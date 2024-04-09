/* -------------------------------------------------------------------------- */
/*                               GCP Foundation                               */
/* -------------------------------------------------------------------------- */

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


variable "services" {
  description = "List of Services to be enabled"
  type        = list(string)
}

variable "service_account_roles" {
  description = "List of roles to be assigned to the existing service account"
  type        = list(string)
}

variable "cloud_build_service_account_roles" {
  description = "List of roles to be assigned to the Cloud Build service account"
  type        = list(string)
}

/* -------------------------------------------------------------------------- */
/*                                 VPC Network                                */
/* -------------------------------------------------------------------------- */


variable "network_name" {
  description = "The name of the VPC network."
  type        = string
}

variable "subnetwork_name" {
  description = "The name of the subnet."
  type        = string
}

variable "ip_cidr_range" {
  description = "The IP address range for the subnet."
  type        = string
}



/* -------------------------------------------------------------------------- */
/*                               Secret Manager                               */
/* -------------------------------------------------------------------------- */


/* -------------------------------- Cloud SQL ------------------------------- */

variable "db_user" {
  description = "The name of the db user."
  type        = string
}

variable "db_password" {
  description = "The password for the db user."
  type        = string

}

variable "db_name" {
  description = "The name of the db."
  type        = string
}

variable "db_port" {
  description = "The port of the db."
  type        = string
}

/* ------------------------------- Cloud Build ------------------------------ */


variable "repo_name" {
  description = "The name of the repository to create the trigger for the Cloud Build."
  type        = string
}

variable "branch" {
  description = "The branch of the repository to create the trigger for the Cloud Build."
  type        = string
}




variable "github_installation_id" {
  description = "The GitHub App installation ID."
  type        = string
}

variable "github_remote_uri" {
  description = "The GitHub remote URI."
  type        = string
}



/* -------------------------------------------------------------------------- */
/*                                  Cloud SQL                                 */
/* -------------------------------------------------------------------------- */


variable "db_version" {
  description = "The database version to use."

}

variable "db_instance_name" {
  description = "The name of the db instance."
  type        = string
}

variable "db_tier" {
  description = "The tier of the db instance."
  type        = string
}


/* -------------------------------------------------------------------------- */
/*                                 Cloud Build                                */
/* -------------------------------------------------------------------------- */

variable "github_token" {
  description = "The GitHub personal access token."
  type        = string
}

/* -------------------------------------------------------------------------- */
/*                                   OpenAI                                   */
/* -------------------------------------------------------------------------- */

variable "openai_api_key" {
  description = "The OpenAI API key."
  type        = string
}

variable "openai_organization" {
  description = "The OpenAI organization."
  type        = string
}

/* -------------------------------------------------------------------------- */
/*                                   FastAPI                                  */
/* -------------------------------------------------------------------------- */

variable "secret_key_access_api" {
  description = "The secret key for the access API."
  type        = string
}

variable "first_superuser" {
  description = "The first superuser."
  type        = string
}

variable "first_superuser_password" {
  description = "The password for the first superuser."
  type        = string
}


