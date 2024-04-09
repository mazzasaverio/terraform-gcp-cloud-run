# Terraform-GCP

## Introduction

This repo is intended to serve as an initial template for setting up and managing the infrastructure required to deploy an image that performs RAG operations on a Postgres database hosted on Cloud SQL (an image that enables the pgvector extension), and it is executed via Cloud Run V2 connected to Redis for caching purposes.

## Prerequisites

- **Sign Up**: Ensure you have an active GCP account. [Sign up here](https://cloud.google.com/) if needed.
- **New Project**: Create a new GCP project. Note down the project ID for future use.
- **Create Service Account**: Create a service account with 'Owner' permissions in your GCP project.
- **Generate Key File**: Generate a JSON key file for this service account and store it securely.
- **Enable Billing**: Ensure billing is enabled on your GCP project for using paid services.

## Terraform Configuration

- **Rename File**: Change `terraform.tfvars.example` to `terraform.tfvars`.
- **Insert Credentials**: Add your credentials to the `terraform.tfvars` file.

## Connecting Cloud Build to Your GitHub Account

- Create a personal access token by navigating to the "Developer settings" in your GitHub account. Select "Personal access tokens" and then "Generate new token". Ensure your token (classic) has no expiration date and grant the following permissions when prompted in GitHub: `repo` and `read:user`. For applications in organizations, also include `read:org` permission.

https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github?generation=2nd-gen#terraform_1

## Connecting to Cloud SQL using Cloud SQL Proxy (Example with DBeaver)

For a secure connection to your Cloud SQL instance from local development environments or database management tools like DBeaver, the Cloud SQL Proxy provides a robust solution. Follow these steps to set up and use the Cloud SQL Proxy:

1. **Download the Cloud SQL Proxy**:
   Use the command below to download the latest version of Cloud SQL Proxy for Linux:

   ```bash
   curl -o cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.8.1/cloud-sql-proxy.linux.amd64
   ```

2. **Make the Proxy Executable**:
   Change the downloaded file's permissions to make it executable:

   ```bash
   chmod +x cloud-sql-proxy
   ```

3. **Start the Cloud SQL Proxy**:
   Launch the proxy with your Cloud SQL instance details. Replace the `[INSTANCE_CONNECTION_NAME]` with your specific Cloud SQL instance connection name:

   ```bash
   ./cloud-sql-proxy --credentials-file=/path/to/credentials_file.json 'project-name:region:instance-name?port=port_number'
   ```

4. **Connect using DBeaver**:
   - Open DBeaver and create a new database connection.
   - Set the host to `localhost` and the port to `5433` (or the port you specified).
   - Provide your Cloud SQL instance's database credentials.

For more details on using the Cloud SQL Proxy, visit the official documentation:
[Google Cloud SQL Proxy Documentation](https://cloud.google.com/sql/docs/postgres/connect-auth-proxy)

## Useful Commands

- **Perform only a few modules (attention to addictions)**:

  ```bash
  terraform apply -target=module.compute_instance
  ```

- **Test Cloud SQL Connection**:
  ```bash
  psql -h private_ip_address -U database_user -d database_name
  ```

## Additional Information

For detailed implementation, refer to the contents of specific `.tf` files within each module's directory.
