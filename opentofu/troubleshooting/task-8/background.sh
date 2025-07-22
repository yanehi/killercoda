#!/bin/bash
# Create provider.tf file

cat <<'EOF' > ~/troubleshooting/task-8/provider.tf
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

touch ~/troubleshooting/task-8/variables.tf
touch ~/troubleshooting/task-8/main.tf
touch ~/troubleshooting/task-8/locals.tf