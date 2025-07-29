#!/bin/bash

# Create solution directory
mkdir -p ~/modules/solution-2

# Create provider.tf file
cat <<'EOF' > ~/modules/solution-2/provider.tf
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

# Create module directory structure
mkdir -p ~/modules/solution-2/modules/nginx_container

# Create variables.tf for the module
cat <<'EOF' > ~/modules/solution-2/modules/nginx_container/variables.tf
variable "network_name" {
  description = "Name of the Docker network"
  type        = string
}

variable "image_name" {
  description = "Name of the Docker image"
  type        = string
}

variable "container_name" {
  description = "Name of the Docker container"
  type        = string
}

variable "port" {
  description = "Port to expose for the nginx container"
  type        = number
  default     = 80
}
EOF

# Create main.tf for the module
cat <<'EOF' > ~/modules/solution-2/modules/nginx_container/main.tf
resource "docker_network" "nginx_network" {
  name = var.network_name
}

resource "docker_image" "nginx_image" {
  name = var.image_name
}

resource "docker_container" "nginx_container" {
  name  = var.container_name
  image = docker_image.nginx_image.image_id

  networks_advanced {
    name = docker_network.nginx_network.name
  }

  ports {
    internal = var.port
    external = var.port
  }
}
EOF

# Create outputs.tf for the module
cat <<'EOF' > ~/modules/solution-2/modules/nginx_container/outputs.tf
output "container_id" {
  description = "ID of the nginx container"
  value       = docker_container.nginx_container.id
}
EOF

# Create the root main.tf
cat <<'EOF' > ~/modules/solution-2/main.tf
module "nginx_latest" {
  source         = "./modules/nginx_container"
  image_name     = "nginx:latest"
  container_name = "my-nginx"
  network_name   = "nginx-net"
}
EOF

# Create the root outputs.tf (this was mentioned as option.tf in the text but should be outputs.tf)
cat <<'EOF' > ~/modules/solution-2/outputs.tf
output "nginx_container_id" {
  description = "ID of the nginx container from the module"
  value       = module.nginx_latest.container_id
}
EOF

echo "Solution created successfully in ~/modules/solution-2!"
