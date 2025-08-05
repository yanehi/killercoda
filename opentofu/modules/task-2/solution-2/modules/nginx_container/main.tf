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

  restart = "unless-stopped"

  ports {
    internal = var.port
    external = var.port
  }

  # Nginx environment variables
  env = [
    "DB_CONTAINER_ID=${var.db_container_id}",
    "DB_HOST=${var.db_host}",
    "DB_PORT=${var.db_port}",
    "DB_PASSWORD=${var.db_password}"
  ]
}
