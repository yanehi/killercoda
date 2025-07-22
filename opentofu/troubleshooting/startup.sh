#!/bin/bash
# Install OpenTofu
if ! command -v tofu &> /dev/null; then
  curl -s https://get.opentofu.org/install.sh | bash
fi
# Install Docker
if ! command -v docker &> /dev/null; then
  apt-get update && apt-get install -y docker.io
fi
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
  echo "$i"
  mkdir ~/troubleshooting/task-$i
done
