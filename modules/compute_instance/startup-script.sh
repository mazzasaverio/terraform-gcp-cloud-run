#!/bin/bash

LOG_FILE="/var/log/startup-script.log"

# Updating and installing required packages
echo "Starting system update and package installation" >> $LOG_FILE
apt-get update >> $LOG_FILE 2>&1
apt-get install -y postgresql-client postgresql-client-common >> $LOG_FILE 2>&1

# Setting up environment variables
echo "Setting up environment variables for database connection" >> $LOG_FILE
DB_USER=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/db-user -H "Metadata-Flavor: Google")
DB_PASS=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/db-pass -H "Metadata-Flavor: Google")
DB_NAME=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/db-name -H "Metadata-Flavor: Google")
DB_HOST=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/db-host -H "Metadata-Flavor: Google")
DB_PORT=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/db-port -H "Metadata-Flavor: Google" || echo '5432')

echo "Exporting environment variables" >> $LOG_FILE
echo "export DB_NAME='${DB_NAME}'" >> ~/.profile
echo "export DB_USER='${DB_USER}'" >> ~/.profile
echo "export DB_PASS='${DB_PASS}'" >> ~/.profile
echo "export DB_HOST='${DB_HOST}'" >> ~/.profile
echo "export DB_PORT='${DB_PORT}'" >> ~/.profile

# Fetching instance user and SSH public key
INSTANCE_USER=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/instance-ssh-user -H "Metadata-Flavor: Google")
SSH_PUBLIC_KEY=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/instance-ssh-public-key -H "Metadata-Flavor: Google")

# Check if user exists, if not create the user and set up SSH access
if ! id "${INSTANCE_USER}" &>/dev/null; then
    echo "Creating user ${INSTANCE_USER}" >> $LOG_FILE
    useradd -m -s /bin/bash "${INSTANCE_USER}"
fi

echo "Setting up SSH access for ${INSTANCE_USER}" >> $LOG_FILE
SSH_DIR="/home/${INSTANCE_USER}/.ssh"
mkdir -p "${SSH_DIR}"
echo "${SSH_PUBLIC_KEY}" | tee -a "${SSH_DIR}/authorized_keys" > /dev/null
chmod 700 "${SSH_DIR}"
chmod 600 "${SSH_DIR}/authorized_keys"
chown -R "${INSTANCE_USER}:${INSTANCE_USER}" "${SSH_DIR}"

# Ensuring permissions are correct for the user's home directory
chmod 755 "/home/${INSTANCE_USER}"
