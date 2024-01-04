# Terraform-GCP

## Introduction

This repository provides configurations for setting up various modular recipes using GCP services. Specifically:

- **VPC Configuration:** A new VPC is configured with the intent to utilize all services within a single VPC.
- **Compute Engine Setup:** A compute engine is set up to read the Cloud SQL via a private IP, configured in another module. A `startup-script.sh` is included, which has code to establish SSH connection directly from the local machine.
- **Cloud Run Creation:** A Cloud Run is created in version V2 with Direct VPC Connection to Cloud SQL.
- **Automated Cloud Build Mechanism:** A mechanism is set where the cloud build is triggered automatically following the code push to the repository that builds the image. An example repository where you can find a sample `cloudbuild.yaml` is at [https://github.com/mazzasaverio/clean-text](https://github.com/mazzasaverio/clean-text). The test code within tests the connection with the Cloud SQL Postgres database via private IP using FastAPI and SQLAlchemy.
  - As a result, the Cloud Run is always updated with the latest version of the image and is triggered every time a file is uploaded to the GCP storage.

## Prerequisites

### 1. Google Cloud Platform Account

- **Sign Up**: Ensure you have an active GCP account. [Sign up here](https://cloud.google.com/) if needed.

### 2. Project Setup

- **New Project**: Create a new GCP project. Note down the project ID for future use.

### 3. Service Account

- **Create Service Account**: Create a service account with 'Owner' permissions in your GCP project.
- **Generate Key File**: Generate a JSON key file for this service account and store it securely.

### 4. Billing

- **Enable Billing**: Ensure billing is enabled on your GCP project for using paid services.

### 5. Connecting Cloud Build to Your GitHub Account

- **Authentication Required**: Connect Cloud Build to your GitHub account as authentication is required.
- **Permissions**: Enable permissions for cloudbuild.gserviceaccount.com to deploy on Cloud Run via the Settings menu on the sidebar.

## Enable APIs

Execute the following in Cloud Shell to enable required APIs:

```
  bash gcloud services enable compute.googleapis.com  sqladmin.googleapis.com  servicenetworking.googleapis.com  pubsub.googleapis.com  run.googleapis.com  cloudbuild.googleapis.com
```

## Terraform Configuration

- **Rename File**: Change `terraform.tfvars.example` to `terraform.tfvars`.
- **Insert Credentials**: Add your credentials to the `terraform.tfvars` file.

## Useful Commands

- **Add SSH Key**:
  ```bash
  ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
  ```
- **Connect via SSH**:
  ```bash
  ssh -i /path/to/your/private/key your_instance_username@external_ip_address
  ```
- **Test Cloud SQL Connection**:
  ```bash
  psql -h private_ip_address -U database_user -d database_name
  ```

## Additional Information

For detailed implementation, refer to the contents of specific `.tf` files within each module's directory.
