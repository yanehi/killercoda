#!/bin/bash
# Create provider.tf file

cat <<EOF > ~/troubleshooting/task-1/provider.tf
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

cat <<EOF > ~/troubleshooting/task-1/variables.tf
variable "environment" {
  type        = bool
  description = "Environment to deploy the container (dev, test, prod)"
  default     = 3
}

variable "nginx_image_tag" {
  type        = string
  description = "Image Tag for Nginx"
  default     = 1
}

# Create the missing variable definition for the alpine_image_tag

EOF

cat <<EOF > ~/troubleshooting/task-1/main.tf
resource "docker_image" "nginx" {
  # Use the value from the locals and variables
  name = ""
}


resource "docker_image" "alpine" {
  name = "${var.alpine_image_name}:local.alpine_image_tag"
}


resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  # Use the value of the nginx_container_name variable
  name  = ""
  ports {
    internal = 80
    external = 8080
  }
}


resource "docker_container" "alpine" {
  image = docker_image.alpine.name
  name  = var.alpine_container_name

  # Keep the container running
  command = ["tail", "-f", "/dev/null"]
}

EOF


cat <<EOF > ~/troubleshooting/task-1/locals.tf
locals {
  # Set the value for the alpine_image_name variable
  # The value represents the name of the docker registry: https://hub.docker.com/_/nginx

  # Set the value for the nginx_image_name variable
  # The value represents the name of the docker registry: https://hub.docker.com/_/alpine


  # Set the value for the alpine_container_name and nginx_container_name variable
  # The value is a concatenated string of "topic4-<alpine|nginx>-" and the value of the "environment" variable

}
EOF
