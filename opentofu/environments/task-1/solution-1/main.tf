# Create a custom Docker network for the application
resource "docker_network" "app_network" {
  name   = var.network_name
  driver = "bridge"

  ipam_config {
    subnet = var.network_subnet
  }
}

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

  # Connect to custom network
  networks_advanced {
    name = docker_network.app_network.name
  }

  # Health check to ensure database is ready
  healthcheck {
    test         = ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${var.db_password}"]
    interval     = "30s"
    timeout      = "10s"
    retries      = 5
    start_period = "60s"
  }

  # Persist database data
  volumes {
    container_path = "/var/lib/mysql"
    host_path      = "/tmp/mysql_data"
  }
}

# Create a docker container hosting the web server
resource "docker_container" "nginx_container" {
  name  = var.web_container_name
  image = docker_image.nginx_image.image_id

  restart = "unless-stopped"

  # Expose web server port
  ports {
    internal = 80
    external = var.web_external_port
  }

  # Connect to custom network
  networks_advanced {
    name = docker_network.app_network.name
  }

  # Environment variables for database connection
  env = [
    "DB_HOST=${docker_container.database_container.name}",
    "DB_PORT=${var.db_port}",
    "DB_NAME=${var.db_name}",
    "DB_USER=${var.db_user}"
  ]

  # Custom HTML page with application information
  upload {
    content = templatefile("${path.root}/index.html.tpl", {
      db_host       = docker_container.database_container.name
      db_port       = var.db_port
      db_name       = var.db_name
      network_name  = var.network_name
      external_port = var.web_external_port
    })
    file = "/usr/share/nginx/html/index.html"
  }

  # Health check for web server
  healthcheck {
    test         = ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:80"]
    interval     = "30s"
    timeout      = "10s"
    retries      = 3
    start_period = "30s"
  }

  # Ensure database is ready before starting web server
  depends_on = [docker_container.database_container]
}



