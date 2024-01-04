# Terraform-GCP Configuration Guide

## Introduction

This repository provides Terraform scripts for configuring two primary services on Google Cloud Platform (GCP):

1. **Compute Engine Instance with Private Connection to Cloud SQL**: Setup a secure, private connection between a Compute Engine instance and a Cloud SQL database.
2. **Cloud Run (V2) with Direct VPC Connection to Cloud SQL**: Establish a Cloud Run service (version 2) with a Direct VPC connection to Cloud SQL, triggered by Pub/Sub messages for file uploads in a storage bucket.

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

## API Configuration

### 1. Google Cloud Shell

- **Access**: Use Google Cloud Shell for command-line interactions with GCP resources.

### 2. Enable APIs

- **Commands**: Execute the following in Cloud Shell to enable required APIs:
  ```bash
  gcloud services enable compute.googleapis.com sqladmin.googleapis.com servicenetworking.googleapis.com
  ```

### 3. Terraform Configuration

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

## Repository Structure

Refer to the repository for module-specific Terraform configurations like `cloud_run`, `cloud_sql`, `compute_instance`, `firewall`, `network`, `pubsub`, and `storage`.

## Additional Information

For detailed implementation, refer to the contents of specific `.tf` files within each module's directory.
