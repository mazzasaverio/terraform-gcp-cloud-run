#!/bin/bash

LOG_FILE="/var/log/startup-script.log"
#to visualiza logs: cat /var/log/startup-script.log
echo "Starting system update and package installation" >> $LOG_FILE
sudo apt-get update >> $LOG_FILE 2>&1

echo "Installing PostgreSQL client and additional components" >> $LOG_FILE
sudo apt-get install -y postgresql-client postgresql-client-common >> $LOG_FILE 2>&1

# Environment variable configuration
echo "Setting up environment variables for database connection" >> $LOG_FILE
DB_USER=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/db-user -H "Metadata-Flavor: Google")
DB_PASS=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/db-pass -H "Metadata-Flavor: Google")
DB_NAME=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/db-name -H "Metadata-Flavor: Google")
DB_HOST=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/db-host -H "Metadata-Flavor: Google")
DB_PORT='5432' # Assuming the default PostgreSQL port

echo "Exporting variables to the user profile" >> $LOG_FILE
echo "export DB_NAME='${DB_NAME}'" >> ~/.profile
echo "export DB_USER='${DB_USER}'" >> ~/.profile
echo "export DB_PASS='${DB_PASS}'" >> ~/.profile
echo "export DB_HOST='${DB_HOST}'" >> ~/.profile
echo "export DB_PORT='${DB_PORT}'" >> ~/.profile

