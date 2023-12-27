# Project Overview

Questa repo contiene la configurazione terraform per connettere tramite connessione privata la cloud run associata a un immagine che legge al cloud sql gcp. Quindi imposta il connector tramite connessione privata

## Prerequisites

Before you begin
Note: The name you use for your project must be between 4 and 30 characters. When you type the name, the form suggests a project ID, which you can edit. The project ID must be between 6 and 30 characters, with a lowercase letter as the first character. You can use a dash, lowercase letter, or digit for the remaining characters, but the last character cannot be a dash.
In the Google Cloud console, on the project selector page, select or create a Google Cloud project.

Note: If you don't plan to keep the resources that you create in this procedure, create a project instead of selecting an existing project. After you finish these steps, you can delete the project, removing all resources associated with the project.
Go to project selector

Make sure that billing is enabled for your Google Cloud project.

Enable the Cloud APIs necessary to run a Cloud SQL sample app on Cloud Run.
Console
gcloud
Click the following button to open Cloud Shell, which provides command-line access to your Google Cloud resources directly from the browser. Cloud Shell can be used to run the gcloud commands presented throughout this quickstart.

Open Cloud Shell

Run the following gcloud command using Cloud Shell:

gcloud services enable compute.googleapis.com sqladmin.googleapis.com run.googleapis.com \
containerregistry.googleapis.com cloudbuild.googleapis.com servicenetworking.googleapis.com
This command enables the following APIs:

Compute Engine API
Cloud SQL Admin API
Cloud Run API
Container Registry API
Cloud Build API
Service Networking API

### Google Cloud

Before starting, ensure you have completed the following preliminary steps:

- Create a Google Cloud Platform account and create a project.
- Create a service account (currently assumed to have Owner permissions).
  - Generate a key and store the .json file in a safe location.
- Enable the necessary APIs in your Google Cloud project:
  - Cloud Resource Manager API
  - Google Container Registry API
  - Cloud Run API
  - Service Networking API
  - Compute Engine API
  - Cloud SQL

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
