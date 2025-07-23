#!/bin/bash

cat <<'EOF' > ~/troubleshooting/task-7/provider.tf
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

cat <<'EOF' > ~/troubleshooting/task-7/variables.tf
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

cat <<'EOF' > ~/troubleshooting/task-7/main.tf
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

  # Keep the container running
  command = ["tail", "-f", "/dev/null"]
}
EOF


cat <<'EOF' > ~/troubleshooting/task-7/locals.tf
locals {
  alpine_image_name = "alpine"
  nginx_image_name  = "nginx"

  alpine_container_name = "topic4-alpine-${var.environment}"
  nginx_container_name  = "topic4-nginx-${var.environment}"
}
EOF
