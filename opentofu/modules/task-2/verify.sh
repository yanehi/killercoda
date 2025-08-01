#!/bin/bash


# Create directory structure in current directory
mkdir -p ./solution-2/modules/nginx_container
mkdir -p ./solution-2/modules/database_container


# Create provider.tf file
cat <<'EOF' > ./solution-2/provider.tf
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

# Create the root main.tf
cat <<'EOF' > ./solution-2/main.tf
# Root module configuration for Task 2
# This uses both nginx and database modules with container ID dependency

module "database" {
  source         = "./modules/database_container"
  image_name     = "mysql:8.0"
  container_name = "my-mysql"
  db_name        = "myapp"
  db_user        = "root"
  db_password    = "password123"
  db_port        = 3306
}

module "nginx_latest" {
  source         = "./modules/nginx_container"
  image_name     = "nginx:latest"
  container_name = "my-nginx"
  port           = 80

  # Pass database container ID, host, and port as variables
  db_container_id = module.database.container_id
  db_host         = module.database.container_name
  db_port         = module.database.db_port
  db_password     = module.database.db_password
}
EOF


# Create variables.tf for the nginx module
cat <<'EOF' > ./solution-2/modules/nginx_container/variables.tf
variable "image_name" {
  description = "Name of the Docker image"
  type        = string
}

variable "container_name" {
  description = "Name of the Docker container"
  type        = string
}

variable "port" {
  description = "Port to expose for the nginx container"
  type        = number
  default     = 80
}

# DB information to be provid as environment variables to the container
variable "db_container_id" {
  description = "DB container id to be included as environment variables to pass to the nginx container"
  type        = string
}

variable "db_host" {
  description = "DB host to be included as environment variables to pass to the nginx container"
  type        = string
}

variable "db_port" {
  description = "DB port to be included as environment variables to pass to the nginx container"
  type        = string
}

variable "db_password" {
  description = "DB password to be included as environment variables to pass to the nginx container"
  type        = string
  sensitive   = true
}

EOF

# Create main.tf for the nginx module
cat <<'EOF' > ./solution-2/modules/nginx_container/main.tf
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
EOF

# Create outputs.tf for the nginx module
cat <<'EOF' > ./solution-2/modules/nginx_container/outputs.tf
output "container_id" {
  description = "ID of the nginx container"
  value       = docker_container.nginx_container.id
}
EOF

# Create variables.tf for the database module
cat <<'EOF' > ./solution-2/modules/database_container/variables.tf
# Database container module - variables.tf
# Input variables for the database container module

variable "image_name" {
  description = "Name of the Docker image"
  type        = string
}

variable "container_name" {
  description = "Name of the Docker container"
  type        = string
}

variable "db_name" {
  description = "Name of the database to create"
  type        = string
}

variable "db_user" {
  description = "Database user name"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Port to expose for the database"
  type        = number
  default     = 3306
}
EOF

# Create main.tf for the database module
cat <<'EOF' > ./solution-2/modules/database_container/main.tf
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
EOF

# Create outputs.tf for the database module
cat <<'EOF' > ./solution-2/modules/database_container/outputs.tf
# Database container module - outputs.tf
# Output values from the database container module

output "container_id" {
  description = "ID of the database container"
  value       = docker_container.database_container.id
}

output "container_name" {
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
}
EOF


echo "Solution-2 structure created successfully!"
