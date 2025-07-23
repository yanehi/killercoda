#!/bin/bash
# Create provider.tf file

cat <<'EOF' > ~/troubleshooting/task-2/provider.tf
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


cat <<'EOF' > ~/resource-dependencies-lifecycle/task-2/main.tf
# Pull the nginx image
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

# Pull the alpine image


# Create a nginx container which depends on the creation of the alpine container
resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = "tutorial-nginx"
  # Hint: Extract the container id from the alpine container
  env = ["ALPINE_DOCKER_CONTAINER_ID=REFERENCE_CONTAINER_ID}"]
  ports {
    internal = 80
    external = 8080
  }
}

# Create an alpine container
## Add the following command to keep the container running =>  command = ["tail", "-f", "/dev/null"]
EOF
