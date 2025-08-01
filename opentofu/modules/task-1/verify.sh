#!/bin/bash

# Create directory structure in current directory
mkdir -p ./solution-1/modules/nginx_container

# Create provider.tf file
cat <<'EOF' > ./solution-1/provider.tf
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

# Create variables.tf for the module
cat <<'EOF' > ./solution-1/modules/nginx_container/variables.tf
variable "image_name" {
  description = "Name of the Docker image"
  type        = string
}

variable "container_name" {
  description = "Name of the Docker container"
  type        = string
}
EOF

# Create main.tf for the module
cat <<'EOF' > ./solution-1/modules/nginx_container/main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

resource "docker_image" "nginx_image" {
  name = var.image_name
}

resource "docker_container" "nginx_container" {
  name  = var.container_name
  image = docker_image.nginx_image.image_id

  ports {
    internal = 80
    external = 80
  }
}
EOF

# Create outputs.tf for the module
cat <<'EOF' > ./solution-1/modules/nginx_container/outputs.tf
EOF

# Create the root main.tf
cat <<'EOF' > ./solution-1/main.tf
module "nginx_latest" {
  source         = "./modules/nginx_container"
  image_name     = "nginx:latest"
  container_name = "my-nginx"
}
EOF

echo "Solution-3 structure created successfully!"