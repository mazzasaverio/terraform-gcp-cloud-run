# Configuring GCP SQL Cloud - Compute Engine with Terraform

This repository provides the resources and instructions necessary to configure an SQL Cloud application through Terraform, enabling a private IP connection with a Google Cloud Platform (GCP) Compute Engine instance.

## Prerequisites

### 1. Google Cloud Platform Account

- **Sign Up**: Ensure you have an active account on the Google Cloud Platform. Sign up [here](https://cloud.google.com/) if you don't have one.

### 2. Project Setup

- **New Project**: Create a new project in your GCP account. Assign it a unique name for easy identification.
- **Project ID**: Note down the project ID. It will be required for future configurations.

### 3. Service Account

- **Create Service Account**: In your GCP project, create a service account with 'Owner' permissions. This account will be utilized by Terraform to manage GCP resources.
- **Generate Key File**: Post creation, generate a JSON key for this service account. Securely store this key as it's vital for authenticating Terraform with GCP.

### 4. Billing

- **Enable Billing**: Ensure that your GCP project has billing enabled. This is crucial for using GCP services that incur costs.

## API Configuration

Activate necessary GCP services by enabling the following APIs:

### 1. Google Cloud Shell

- **Access**: Use the Google Cloud Shell for command-line interactions with GCP resources. It can be accessed directly from your browser.

### 2. Enable APIs

- **Commands**: In the Cloud Shell, execute the following command to activate the required APIs:

  - Service Networking API
  - Cloud SQL Admin API
  - Compute Engine API
  - Cloud Resource Manager API

  ```bash
  gcloud services enable compute.googleapis.com sqladmin.googleapis.com servicenetworking.googleapis.com
  ```

### 3. Terraform Configuration

- **Rename File**: Change the name of `terraform.tfvars.example` to `terraform.tfvars`.
- **Insert Credentials**: Add your specific credentials into the `terraform.tfvars` file.

## Useful Commands

To add an SSH key, execute locally:

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

To connect via SSH:

```bash
ssh -i /path/to/your/private/key your_instance_username@external_ip_address
```

To test the connection to Cloud SQL:

```bash
psql -h private_ip_address -U database_user -d database_name
```
