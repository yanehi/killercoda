#!/bin/bash
# Create provider.tf file

cat <<'EOF' > ~/resource-dependencies-lifecycle/solution-2/provider.tf
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


cat <<'EOF' > ~/resource-dependencies-lifecycle/solution-2/main.tf
# Pull the nginx image
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

# Pull the alpine image
resource "docker_image" "alpine" {
  name = "alpine:latest"
}

# Create a nginx container which depends on the creation of the alpine container
resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = "tutorial-nginx"
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
  name  = "topic2-alpine"

  # Keep the container running
  command = ["tail", "-f", "/dev/null"]
}
EOF
