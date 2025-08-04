#!/bin/bash

# Create provider.tf file
cat <<'EOF' > ~/modules/task-1/provider.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}
EOF

echo "Task-1 structure created successfully!" 