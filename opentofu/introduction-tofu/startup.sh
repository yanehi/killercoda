#!/bin/bash

mkdir ~/introduction-tofu/lifecycle-management

# Install Docker
if ! command -v docker &> /dev/null; then
  apt-get update && apt-get install -y docker.io
fi
# Start Docker service if not running
if ! pgrep dockerd &> /dev/null; then
  systemctl start docker
fi
# Verify installations
docker --version 