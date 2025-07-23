#!/bin/bash
# Create provider.tf file

cat <<'EOF' > ~/troubleshooting/task-1/provider.tf
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


cat <<'EOF' > ~/resource-dependencies-lifecycle/task-1/main.tf
# Pulls the image
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

# Pull the alpine image


# Create a nginx container which depends on the private_network and the creation of an alpine container
resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = "topic2-nginx"

  ports {
    internal = 80
    external = 8080
  }

  # Create an explicit dependency on the alpine container

}

# Create an alpine container
## Add the following command to keep the container running =>  command = ["tail", "-f", "/dev/null"]
EOF
