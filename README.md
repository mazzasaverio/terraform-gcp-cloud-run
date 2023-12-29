# Terraform Configuration for GCP Cloud SQL and Cloud Run Connection

This repository allows you to configure an SQL Cloud application through Terraform with a private IP connection with a GCP compute engine

## Prerequisites

1. **Google Cloud Platform Account**: Create an account on the Google Cloud Platform (GCP)

2. **Project Creation**: Create a new project in your GCP account. Assign it a unique name and keep track of the project ID for future reference.

3. **Service Account Creation**:

   - In your GCP project, create a service account with Owner permissions. This account will be used to manage resources via Terraform.
   - After creating the service account, generate a JSON key file. Store this file securely as it will be used to authenticate your Terraform configuration.

4. **Billing**: Ensure that billing is enabled for your GCP project. This is necessary to use GCP resources that may incur costs.

### Enabling Required APIs

To ensure your project can interact with necessary GCP services, enable the following APIs using the Google Cloud Shell:

1. **Open Google Cloud Shell**: Access the Cloud Shell directly from your browser, which provides a command-line interface to your GCP resources.

2. **Activate APIs**: Run the following command in the Cloud Shell to enable the required APIs:

   - Service Networking API
   - Cloud SQL Admin API
   - Compute Engine API
   - Cloud Resource Manager API

   ```bash
   gcloud services enable compute.googleapis.com sqladmin.googleapis.com run.googleapis.com servicenetworking.googleapis.com
   ```

<!--
### Create and download SSL server and client certificates

1. In the Google Cloud console, go to the **Cloud SQL Instances** page.

   [Go to Cloud SQL Instances](https://console.cloud.google.com/sql)

2. Click the `quickstart-instance` to see its **Overview** page
3. Click the **Connections** tab.
4. Under the **Security** section, click **Create client certificate**.
5. In the **Create a client certificate** dialog, enter `quickstart-key` as the name and click **Create**.
6. In the **New SSL certificate created** dialog, click each download link to download the certificates. Then, click **Close**.

   **Important:** Store this private key securely. If you lose it, you must create a new client certificate.

Run the following command in Cloud Shell to build a Docker container and publish it to Container Registry. Replace **YOUR_PROJECT_ID** with your project's project id.

    ```
    gcloud builds submit --tag gcr.io/project-gcp-v1/run-sql
    ```

**Deploy the sample app**

Di seguito i link utili:

- https://cloud.google.com/sql/docs/postgres/connect-run

Attenzione:

Error while adding or updating a new subnet under VPC Private Service Connection

bookmark_border
Problem
While creating or removing a private service connection, the below error was observed:

Cannot modify allocated ranges in CreateConnection. Please use UpdateConnection.
Environment
VPC Networking
Private Service Connection
Solution
To recreate the connection (once deleted), you have to use the gcloud command as mentioned below.

gcloud services vpc-peerings update --service=servicenetworking.googleapis.com --ranges=[Allocated_Range_Name] --network=[netowrk_name] --project=[project_id] --force
Cause
Creating a private connection is a one-time procedure. Generally this error generates, when you delete the previously created connection and allocated IP range and try recreating the new connection with previous allocated ranges.

## Additional Resources

- [Connecting Cloud Run to Cloud SQL](https://cloud.google.com/sql/docs/postgres/connect-run)
- [Terraform Documentation](https://www.terraform.io/docs) -->
