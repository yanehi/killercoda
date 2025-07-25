#!/bin/bash

cat <<'EOF' > ~/tmp/task-9/provider.tf
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

cat <<'EOF' > ~/tmp/task-9/main.tf
locals {
  nginx_image_name  = "nginx"
  nginx_container_name  = "topic4-nginx-dev"
}

resource "docker_image" "nginx" {
  name = "${local.nginx_image_name}:latest"
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = local.nginx_container_name
  ports {
    internal = 80
    external = 8080
  }
}
EOF

cd ~/tmp/task-9
tofu apply -auto-approve






cat <<'EOF' > ~/troubleshooting/task-9/provider.tf
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

cat <<'EOF' > ~/troubleshooting/task-9/variables.tf
variable "environment" {
  type        = string
  description = "Environment to deploy the container (dev, test, prod)"
  default     = "dev"
}

variable "nginx_image_tag" {
  type        = string
  description = "Image Tag for Nginx"
  default     = "latest"
}

variable "alpine_image_tag" {
  type        = string
  description = "Image Tag for Alpine"
  default     = "latest"
}
EOF

cat <<'EOF' > ~/troubleshooting/task-9/main.tf
# Pull the nginx image
resource "docker_image" "nginx" {
  name = "${local.nginx_image_name}:${var.nginx_image_tag}"
}

# Pull the alpine image
resource "docker_image" "alpine" {
  name = "${local.alpine_image_name}:${var.alpine_image_tag}"
}

# Create a nginx container which depends on the creation of the alpine container
resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = local.nginx_container_name
  # Set an environment variable with the value of the container id from the alpine container
  env = ["ALPINE_DOCKER_CONTAINER_ID=${docker_container.alpine.id}"]
  ports {
    internal = 80
    external = 8080
  }
}

# Create an alpine container
resource "docker_container" "alpine" {
  image = docker_image.alpine.name
  name  = local.alpine_container_name
  volumes {
    read_only = true
    host_path = "${path.cwd}/files/"
    container_path = "/files"
  }

  # Keep the container running
  command = ["tail", "-f", "/dev/null"]
}

data "docker_logs" "nginx_logs" {
  name = docker_container.nginx.name
  details = false
  follow = false
  logs_list_string_enabled = true
  show_stderr = false
  show_stdout = true
  timestamps = false
}
EOF


cat <<'EOF' > ~/troubleshooting/task-9/locals.tf
locals {
  alpine_image_name = "alpine"
  nginx_image_name  = "nginx"

  alpine_container_name = "topic4-alpine-${var.environment}"
  nginx_container_name  = "topic4-nginx-${var.environment}"
}
EOF
