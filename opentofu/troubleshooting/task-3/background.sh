#!/bin/bash

cat <<'EOF' > ~/troubleshooting/task-3/provider.tf
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

cat <<'EOF' > ~/troubleshooting/task-3/variables.tf
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

# variable "alpine_image_tag" {
#   type        = string
#   description = "Image Tag for Alpine"
#   default     = "latest"
# }
EOF

cat <<'EOF' > ~/troubleshooting/task-3/main.tf
resource "docker_image" "nginx" {
  # Here is an syntax error
  name = "${locals.nginx_image_name}:${var.nginx_image_tag}"
}

# Here is an syntax error
resource "docker_image" {
  # Here is an syntax error
  name = "${locals.alpine_image_name}:${var.alpine_image_tag}"
}

# Here is an syntax error
resource "docker_container" "nginx" {
  name  = local.nginx_container_name
  env = ["ALPINE_DOCKER_CONTAINER_ID=${docker_container.alpine.id}"]
  # Here is an syntax error
  ports [
    internal = 80
    external = 8080
  ]
}


resource "docker_container" "alpine" {
  image = docker_image.alpine.name
  name  = local.alpine_container_name

  # Here is an syntax error
  command = ["tail" "-f" "/dev/null"]
}
EOF


cat <<'EOF' > ~/troubleshooting/task-3/locals.tf
locals {
  alpine_image_name = "alpine"
  nginx_image_name  = "nginx"

  # Here is an syntax error
  alpine_container_name = "topic4-alpine-{var.environment}"
  nginx_container_name  = "topic4-nginx-${var.environment}"
}
EOF
