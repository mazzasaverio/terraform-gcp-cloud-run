# Project Overview

Questa repo contiene la configurazione terraform per connettere tramite connessione privata la cloud run associata a un immagine che legge al cloud sql gcp. Quindi imposta il connector tramite connessione privata

## Prerequisites

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
