#!/bin/bash
# Install OpenTofu
#!/bin/bash

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

apt-get update && apt-get install -y docker.io

# Start Docker service if not running
if ! pgrep dockerd &> /dev/null; then
  systemctl start docker
fi
# Verify installations
tofu version
docker --version

# Create folder with exercises
mkdir ~/troubleshooting
for i in {1..8}; do
  echo "Create folder task-$i"
  mkdir ~/troubleshooting/task-$i
done
