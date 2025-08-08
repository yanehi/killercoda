#!/bin/bash

# Create folder with exercises
mkdir ~/modules
for i in {1..3}; do
  echo "Create folder task-$i and solution-$i"
  mkdir ~/modules/task-$i
  mkdir ~/modules/solution-$i
done

# Update packages
apt-get update -y

# Install OpenTofu

# Download the installer script:
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
# Alternatively: wget --secure-protocol=TLSv1_2 --https-only https://get.opentofu.org/install-opentofu.sh -O install-opentofu.sh

# Give it execution permissions:
chmod +x install-opentofu.sh

# Please inspect the downloaded script

# Run the installer:
./install-opentofu.sh --install-method deb

# Remove the installer:
rm -f install-opentofu.sh

# Install Docker
apt-get install -y docker.io

# Start Docker service
systemctl start docker
systemctl enable docker

# Verify installations
tofu version
docker --version