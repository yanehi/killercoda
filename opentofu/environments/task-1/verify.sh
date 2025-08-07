#!/bin/bash

# Create solution-1 directory structure
mkdir -p ~/environments/task-1/solution-1/env

# Create provider.tf file
cat <<'EOF' > ~/environments/task-1/solution-1/provider.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}
EOF

# Create variables.tf file
cat <<'EOF' > ~/environments/task-1/solution-1/variables.tf
# Environment variable
variable "environment" {
  description = "Environment name (dev, prod, staging, etc.)"
  type        = string
  default     = "dev"
}

# Application URL variable
variable "app_url" {
  description = "Application URL to access the web application"
  type        = string
  default     = "http://localhost:8080"
}

# Database variables
variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "webapp_db"
}

variable "db_user" {
  description = "Database user name"
  type        = string
  default     = "webapp_user"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "secure_password_123"
  sensitive   = true
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "container_name" {
  description = "Name of the database container"
  type        = string
  default     = "webapp-database"
}

# Web server variables
variable "image_name" {
  description = "Docker image name for the web server"
  type        = string
  default     = "nginx:alpine"
}

variable "web_container_name" {
  description = "Name of the web server container"
  type        = string
  default     = "webapp-nginx"
}

variable "web_external_port" {
  description = "External port for the web server"
  type        = number
  default     = 8080
}

# Network variables
variable "network_name" {
  description = "Docker network name"
  type        = string
  default     = "webapp-network"
}

variable "network_subnet" {
  description = "Network subnet"
  type        = string
  default     = "172.20.0.0/16"
}
EOF

# Create main.tf file
cat <<'EOF' > ~/environments/task-1/solution-1/main.tf
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
  name         = "mysql:8.0"
  keep_locally = true  # Verhindert das Löschen des Images beim destroy
}

# Create a docker image for nginx container
resource "docker_image" "nginx_image" {
  name         = var.image_name
  keep_locally = true  # Verhindert das Löschen des Images beim destroy
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

# Create nginx container for web server
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

  # Upload custom index.html from template
  upload {
    file = "/usr/share/nginx/html/index.html"
    content = templatefile("${path.root}/index.html.tpl", {
      db_host       = docker_container.database_container.name
      db_name       = var.db_name
      db_port       = var.db_port
      network_name  = var.network_name
      external_port = var.web_external_port
      environment   = var.environment
      app_url       = var.app_url
    })
  }

  depends_on = [docker_container.database_container]
}

# Step 4: Conditional Resource Creation
# Debug container for development (Redis for caching/sessions)
resource "docker_image" "redis_image" {
  count = var.environment == 'dev' ? 1 : 0
  name  = "redis:alpine"
  keep_locally = true
}

resource "docker_container" "debug_container" {
  count = var.environment == 'dev' ? 1 : 0
  name  = "${var.environment}-debug-redis"
  image = docker_image.redis_image[0].image_id

  ports {
    internal = 6379
    external = 6379
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  restart = "unless-stopped"
}

# Backup container for production
resource "docker_image" "backup_image" {
  count = var.environment == 'prod' ? 1 : 0
  name  = "mysql:8.0"
  keep_locally = true
}

resource "docker_container" "backup_container" {
  count = var.environment == 'prod' ? 1 : 0
  name  = "${var.environment}-backup-service"
  image = docker_image.backup_image[0].image_id

  command = [
    "sh", "-c",
    "while true; do echo 'Running backup at $(date)'; sleep 3600; done"
  ]

  networks_advanced {
    name = docker_network.app_network.name
  }

  restart = "unless-stopped"
}
EOF

# Create index.html.tpl template
cat <<'EOF' > ~/environments/task-1/solution-1/index.html.tpl
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Web Application - ${environment} Environment</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f4f4f4;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .info-box {
            background-color: #e7f3ff;
            border: 1px solid #bee5ff;
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
        }
        .success {
            background-color: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Web Application - ${environment} Environment</h1>

        <div class="info-box success">
            <strong>��� Application Successfully Deployed</strong><br>
            Your OpenTofu/Terraform configuration has been successfully applied!
        </div>

        <h2>Environment Information</h2>
        <table>
            <tr>
                <th>Property</th>
                <th>Value</th>
            </tr>
            <tr>
                <td>Environment</td>
                <td>${environment}</td>
            </tr>
            <tr>
                <td>Application URL</td>
                <td><a href="${app_url}" target="_blank">${app_url}</a></td>
            </tr>
            <tr>
                <td>External Port</td>
                <td>${external_port}</td>
            </tr>
        </table>

        <h2>Infrastructure Details</h2>
        <table>
            <tr>
                <th>Component</th>
                <th>Details</th>
            </tr>
            <tr>
                <td>Database Host</td>
                <td>${db_host}</td>
            </tr>
            <tr>
                <td>Database Name</td>
                <td>${db_name}</td>
            </tr>
            <tr>
                <td>Database Port</td>
                <td>${db_port}</td>
            </tr>
            <tr>
                <td>Network Name</td>
                <td>${network_name}</td>
            </tr>
        </table>

        <div class="info-box">
            <strong>Note:</strong> This is a demonstration application created with OpenTofu/Terraform.
            The database and web server are running in Docker containers and connected via a custom network.
        </div>
    </div>
</body>
</html>
EOF

# Create dev.tfvars file
cat <<'EOF' > ~/environments/task-1/solution-1/env/dev.tfvars
# Environment configuration
environment = "dev"
app_url     = "http://localhost:8080"

# Database configuration
db_name        = "webapp_db_dev"
db_user        = "webapp_user_dev"
db_password    = "secure_password_123"
db_port        = 3306
container_name = "webapp-database-dev"

# Web server configuration
image_name         = "nginx:alpine"
web_container_name = "webapp-nginx-dev"
web_external_port  = 8080

# Network configuration
network_name   = "webapp-network-dev"
network_subnet = "172.20.0.0/16"

# Step 4: Conditional resources
enable_debug_container  = true
enable_backup_container = false
EOF

# Create prod.tfvars file
cat <<'EOF' > ~/environments/task-1/solution-1/env/prod.tfvars
# Environment configuration
environment = "prod"
app_url     = "http://localhost:80"

# Database configuration
db_name        = "webapp_db_prod"
db_user        = "webapp_user_prod"
db_password    = "zP8~99^1W7zA"
db_port        = 3307
container_name = "webapp-database-prod"

# Web server configuration
image_name         = "nginx:latest"
web_container_name = "webapp-nginx-prod"
web_external_port  = 80

# Network configuration
network_name   = "webapp-network-prod"
network_subnet = "172.21.0.0/16"

# Step 4: Conditional resources
enable_debug_container  = false
enable_backup_container = true
EOF

echo "Solution-1 directory structure created successfully!"
