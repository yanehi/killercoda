#!/bin/bash

# Create the solution directory structure
mkdir -p ~/modules/solution-3/modules/database_container

# Create main.tf for the database module
cat <<'EOF' > ~/modules/solution-3/modules/database_container/main.tf
# Database container module - main.tf
# Defines MySQL container with environment configuration

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
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

# Create variables.tf for the database module
cat <<'EOF' > ~/modules/solution-3/modules/database_container/variables.tf
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

# Create outputs.tf for the database module
cat <<'EOF' > ~/modules/solution-3/modules/database_container/outputs.tf
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

# Create provider.tf file
cat <<'EOF' > ~/modules/solution-3/provider.tf
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

# Create main.tf with version 4.0.0 (working version)
cat <<'EOF' > ~/modules/solution-3/main.tf
# Root module configuration for Task 3
# This uses a database module and a module from the Terraform Registry

module "database" {
  source         = "./modules/database_container"
  image_name     = "mysql:8.0"
  container_name = "my-mysql"
  db_name        = "myapp"
  db_user        = "root"
  db_password    = "password123"
  db_port        = 3306
}

# Nginx module from Terraform Module Registry - Version 4.0.0
module "nginx" {
  source  = "JamaicaBot/docker-ngnix/kreuzwerker"
  version = "4.0.0"

  # Basic configuration
  image_name     = "nginx:alpine"
  container_name = "my-nginx"
  port           = 8080

  # Database connection as environment variables
  db_container_id = module.database.container_id
  db_host         = module.database.container_name
  db_port         = module.database.db_port
  db_password     = module.database.db_password
}
EOF

# Create main.tf with version 5.0.0 (breaking changes version)
cat <<'EOF' > ~/modules/solution-3/main_v5.tf
# Root module configuration for Task 3
# This uses a database module and a module from the Terraform Registry

module "database_v5" {
  source         = "./modules/database_container"
  image_name     = "mysql:8.0"
  container_name = "my-mysql"
  db_name        = "myapp"
  db_user        = "root"
  db_password    = "password123"
  db_port        = 3306
}

# Nginx module from Terraform Module Registry - Version 5.0.0
# This version has changes in variable names
module "nginx_v5" {
  source  = "JamaicaBot/docker-ngnix/kreuzwerker"
  version = "5.0.0"

  # Basic configuration
  image_name     = "nginx:alpine"
  container_name = "my-nginx"
  port           = 8080

  # Database connection as environment variables
  db_container_id = module.database_v5.container_id
  db_host         = module.database_v5.container_name
  db_port         = module.database_v5.db_port
  db_password     = module.database_v5.db_password
}
EOF

# Create main.tf with version 6.0.0 (new html content version)
cat <<'EOF' > ~/modules/solution-3/main_v6.tf
# Root module configuration for Task 3
# This uses a database module and a module from the Terraform Registry

module "database_v5" {
  source         = "./modules/database_container"
  image_name     = "mysql:8.0"
  container_name = "my-mysql"
  db_name        = "myapp"
  db_user        = "root"
  db_password    = "password123"
  db_port        = 3306
}

# Nginx module from Terraform Module Registry - Version 6.0.0
# This version has changes in variable names
module "nginx_v6" {
  source  = "JamaicaBot/docker-ngnix/kreuzwerker"
  version = "6.0.0"

  # Basic configuration
  image_name     = "nginx:alpine"
  container_name = "my-nginx"

  # Database connection as environment variables
  db_container_id = module.database_v6.container_id
  db_host         = module.database_v6.container_name
  db_port         = module.database_v6.db_port
  db_password     = module.database_v6.db_password
}
EOF

# Create a README file explaining the differences
cat <<'EOF' > ~/modules/solution-3/README.md
# Task 3 Solution

## Version 4.0.0 (Working)
- Uses `main.tf` with version 4.0.0 of the JamaicaBot/docker-nginx module
- Variable names: `image_name`, `container_name`, `port`, `environment_variables`
- This version works correctly with the provided configuration

## Version 5.0.0 (Breaking Changes)
- Uses `main_v5.tf` with version 5.0.0 of the JamaicaBot/docker-ngnix module
- Variable names changed: `docker_image`, `name`, `external_port`, `env`
- This version demonstrates breaking changes that cause validation errors

## Version 6.0.0 (Security Risk)
- Uses `main_v6.tf` with version 6.0.0 of the JamaicaBot/docker-ngnix module
- HTML content was added to the module
- This version demonstrates unwanted content that was included to the new version

## Key Differences
1. **Variable Names**: The module changed its input variable names between versions
2. **Environment Variables**: Changed from `environment_variables` map to `env` list
3. **Port Configuration**: Changed from `port` to `external_port`

## Learning Points
- Always pin module versions in production
- Test module updates in development first
- Breaking changes can occur even in minor version updates
- Read module changelogs before upgrading
EOF

echo "Solution-3 structure created successfully!"
