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

# Create a main.tf
cat <<'EOF' > ~/modules/task-1/main.tf
module "nginx" {
     source       = "./modules/nginx_container"
     image        = "nginx:latest"
     container_name = "my-nginx"
     network_name = "nginx-net"
   }
EOF

# Create an option.tf
cat <<'EOF' > ~/modules/task-1/option.tf
output "container_id" {
  value = # reference the modules output to display the container ID
}
EOF