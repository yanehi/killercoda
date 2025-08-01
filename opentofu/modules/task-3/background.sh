#!/bin/bash

# Install Terraform for Linux (required for Task 3)
echo "Installing Terraform for Linux..."

# Check if Terraform is already installed
if ! command -v terraform &> /dev/null; then
    echo "Terraform not found. Installing..."
    
    # Download and install Terraform
    TERRAFORM_VERSION="1.5.7"
    TERRAFORM_ZIP="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
    TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${TERRAFORM_ZIP}"
    
    # Download Terraform
    wget -O /tmp/${TERRAFORM_ZIP} ${TERRAFORM_URL}
    
    # Unzip and install
    unzip /tmp/${TERRAFORM_ZIP} -d /tmp/
    sudo mv /tmp/terraform /usr/local/bin/
    
    # Clean up
    rm /tmp/${TERRAFORM_ZIP}
    
    # Verify installation
    terraform --version
    echo "Terraform installation completed successfully!"
else
    echo "Terraform is already installed:"
    terraform --version
fi

# Create directory structure in current directory
mkdir -p ~/modules/task-3/modules/database_container

# Create provider.tf file
cat <<'EOF' > ~/modules/task-3/provider.tf
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

# Create a main.tf with TODO structure
cat <<'EOF' > ~/modules/task-3/main.tf
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

# TODO: Add the nginx module from the Terraform Module Registry here
# Search for "JamaicaBot/docker-nginx" in the registry
# Use version "4.0.0" initially
# The module should use the database container information as environment variables
# module "nginx" {
#   source = "JamaicaBot/docker-nginx/kreuzwerker"
#   version = "4.0.0"
#   # Add required variables based on the module documentation
# }
EOF

# Create main.tf for the database module
cat <<'EOF' > ~/modules/task-3/modules/database_container/main.tf
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

# Create variables.tf for the database module
cat <<'EOF' > ~/modules/task-3/modules/database_container/variables.tf
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
cat <<'EOF' > ~/modules/task-3/modules/database_container/outputs.tf
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

echo "Task-3 structure created successfully!"
echo "Terraform is ready for downloading modules from the Terraform Registry"
echo "Ready for students to complete the TODO section in main.tf"