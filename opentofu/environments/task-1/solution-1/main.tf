

# Create a docker image for the database
resource "docker_image" "database_image" {
  name = "mysql:8.0"
}

# Create a docker image for a ngnix containerasdasdad
resource "docker_image" "nginx_image" {
  name = var.image_name
}


# Create a docker container hosting database
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