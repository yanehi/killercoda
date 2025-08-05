# Database container module - main.tf
# Defines MySQL container with environment configuration

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

resource "docker_image" "database_image" {
  name = var.image_name
}

resource "docker_container" "database_container" {
  name  = var.container_name
  image = docker_image.database_image.image_id

   restart = "unless-stopped"

  # Database environment variables
  env = [
    "MYSQL_ROOT_PASSWORD=${var.db_password}",
    "MYSQL_DATABASE=${var.db_name}",
    "MYSQL_USER=${var.db_user}",
    "MYSQL_PASSWORD=${var.db_password}"
  ]

  # Expose database port
  ports {
    internal = var.db_port
    external = var.db_port
  }

  # Health check to ensure database is ready
  healthcheck {
    test         = ["CMD", "mysqladmin", "ping", "-h", "localhost"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "30s"
  }
}
