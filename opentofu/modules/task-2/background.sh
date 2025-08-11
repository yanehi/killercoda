#!/bin/bash

# Create the required directory structure
mkdir -p ~/modules/project/modules/database_container

# Create provider.tf file in database_container module
cat <<'EOF' >~/modules/project/modules/database_container/provider.tf
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

# Create a main.tf
cat <<'EOF' >  ~/modules/project/modules/database_container/main.tf
# Database container module - main.tf
# Defines MySQL container with environment configuration

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
EOF


# Create index.html.tpl for the nginx container
cat <<'EOF' >  ~/modules/project/modules/database_container/variables.tf
variable "image_name" {
  description = "Docker image name for database"
  type        = string
  default     = "mysql:8.0"
}

variable "container_name" {
  description = "Name of the database container"
  type        = string
  default     = "database-container"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "myapp"
}

variable "db_user" {
  description = "Database user"
  type        = string
  default     = "root"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

EOF

# Create variables.tf for the module
cat <<'EOF' >  ~/modules/project/modules/database_container/outputs.tf
# Database container module - outputs.tf
# Output values from the database container module

output "container_id" {
  description = "ID of the database container"
  value       = docker_container.database_container.id
}

output "db_host" {
  description = "Name of the database container"
  value       = docker_container.database_container.name
}

output "db_port" {
  description = "Port exposed by the database container"
  value       = var.db_port
}

output "db_password" {
  description = "Password exposed by the database container"
  value       = var.db_password
  sensitive   = true
}
EOF

# Create main.tf for the module
cat <<'EOF' >  ~/modules/project/database.tf
module "database" {
  source         = "./modules/database_container"
  image_name     = "mysql:8.0"
  container_name = "my-mysql"
  db_name        = "myapp"
  db_user        = "root"
  db_password    = "password123"
  db_port        = 3306
}
EOF

echo "Task-2 structure created successfully!"