#!/bin/bash

# Create the solution directory structure
mkdir -p ~/modules/project/solution-2/modules/database_container

# Create provider.tf file
cat <<'EOF' > ~/modules/project/solution-2/provider.tf
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

# Create the root main.tf with both nginx modules and database module
cat <<'EOF' > ~/modules/project/solution-2/main.tf
# Root module configuration for Task 2
# This uses nginx and database modules with proper integration

module "nginx_production" {
  source         = "./modules/nginx_container"
  image_name     = "docker.io/library/nginx:latest"
  container_name = "web_server_production"
  external_port  = 80
  environment    = "production"

  # Database integration - Task 2
  db_host     = module.database.container_name
  db_port     = module.database.db_port
  db_password = module.database.db_password
}

module "nginx_development" {
  source         = "./modules/nginx_container"
  image_name     = "docker.io/library/nginx:1.29.0"
  container_name = "web_server_development"
  external_port  = 8080
  environment    = "development"

  # Database integration - Task 2
  db_host     = module.database.container_name
  db_port     = module.database.db_port
  db_password = module.database.db_password
}
EOF

# Create database.tf file as mentioned in the task description
cat <<'EOF' > ~/modules/project/solution-2/database.tf
# Database module initialization
# This file demonstrates how the database module is configured
module "database" {
  source         = "./modules/database_container"
  image_name     = "mysql:8.0"
  container_name = "webapp-database"
  db_name        = "webapp_db"
  db_user        = "root"
  db_password    = "password123"
  db_port        = 3306
}
EOF

# Create index.html.tpl template file
cat <<'EOF' > ~/modules/project/solution-2/index.html.tpl
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terraform Web Application Stack - ${upper(environment)} Environment</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            background-color: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.5em;
        }
        .info-box {
            background: linear-gradient(45deg, #e8f4fd, #f0f8ff);
            padding: 20px;
            border-left: 5px solid #3498db;
            margin: 25px 0;
            border-radius: 5px;
        }
        .status-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin: 20px 0;
        }
        .status {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
        .success {
            color: #27ae60;
            font-weight: bold;
        }
        .highlight {
            color: #e74c3c;
            font-weight: bold;
        }
        .env-var {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }
        .env-item {
            display: flex;
            justify-content: space-between;
            margin: 10px 0;
            padding: 8px;
            background-color: white;
            border-radius: 5px;
            border-left: 4px solid #3498db;
        }
        ul {
            list-style-type: none;
            padding: 0;
        }
        li {
            margin: 8px 0;
            padding: 5px 0;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>🚀 Terraform Web Application Stack - ${upper(environment)} Environment</h1>

    <div class="info-box">
        <h3>📊 Application Status</h3>
        <div class="status-grid">
            <div class="status">
                <span>🌐 Web Server:</span>
                <span class="success">✅ Running</span>
            </div>
            <div class="status">
                <span>🏷️ Environment:</span>
                <span class="highlight">${upper(environment)}</span>
            </div>
            <div class="status">
                <span>📡 Port:</span>
                <span class="highlight">80</span>
            </div>
            <div class="status">
                <span>🔗 Application URL:</span>
                <span class="highlight"><a href="http://localhost:80" target="_blank">http://localhost:80</a></span>
            </div>
        </div>
    </div>

    <div class="env-var">
        <h3>🔧 Container Environment Variables</h3>
        <div class="env-item">
            <strong>ENVIRONMENT:</strong>
            <span>${environment}</span>
        </div>
        <div class="env-item">
            <strong>SERVER_NAME:</strong>
            <span>web_server_${environment}</span>
        </div>
        <div class="env-item">
            <strong>DATABASE_HOST:</strong>
            <span>${db_host != "" ? db_host : "(empty - will be set in Task 2)"}</span>
        </div>
        <div class="env-item">
            <strong>DATABASE_PORT:</strong>
            <span>${db_port != "" ? db_port : "(empty - will be set in Task 2)"}</span>
        </div>
    </div>

    <div class="info-box">
        <h4>💡 Terraform/OpenTofu Learning Objectives</h4>
        <ul>
            <li>✅ <strong>Resource Management:</strong> Docker Images and Containers</li>
            <li>✅ <strong>Environment Variables:</strong> Container configuration via env block</li>
            <li>✅ <strong>Template Files:</strong> Dynamic HTML generation with templatefile()</li>
            <li>✅ <strong>Variable Usage:</strong> Parameterized configuration</li>
            <li>✅ <strong>Multi-environment:</strong> Support for dev/prod environments</li>
        </ul>
    </div>

    <div class="info-box">
        <p><strong>🎯 Note:</strong> This application demonstrates Environment Variables integration
            with Terraform templatefile() function. The container env block sets environment variables
            that correspond to the values shown above.</p>

        <p><strong>🚀 Deployment:</strong> Use <code>tofu init</code>, <code>tofu plan</code> and
            <code>tofu apply</code> to deploy this infrastructure.</p>

        <p><strong>🔧 Environment:</strong> Currently running in <strong>${upper(environment)}</strong> mode.</p>
    </div>
</div>
</body>
</html>
EOF

# Create variables.tf for the nginx module (Task 1 + Task 2 variables)
cat <<'EOF' > ~/modules/project/solution-2/modules/nginx_container/variables.tf
variable "image_name" {
  description = "Docker image name for nginx"
  type        = string
}

variable "container_name" {
  description = "Name of the nginx container"
  type        = string
}

variable "external_port" {
  description = "External port for nginx"
  type        = number
}

variable "environment" {
  description = "The environment for the nginx container (e.g., production, development)"
  type        = string
}

# Task 2 Variables - Database integration
variable "db_host" {
  description = "Database host for nginx container"
  type        = string
}

variable "db_port" {
  description = "Database port for nginx container"
  type        = number
}

variable "db_password" {
  description = "Database password for nginx container"
  type        = string
  sensitive   = true
}
EOF

# Create main.tf for the nginx module (based on main_ausgangslage.tf)
cat <<'EOF' > ~/modules/project/solution-2/modules/nginx_container/main.tf
# Nginx container module - main.tf
# Defines nginx container with environment configuration

resource "docker_image" "nginx" {
  name = var.image_name
}

resource "docker_container" "nginx_container" {
  name     = var.container_name
  image    = docker_image.nginx.name
  pid_mode = "host"

  ports {
    internal = 80
    external = var.external_port
  }

  # Set environment variables with database integration
  env = [
    "ENVIRONMENT=${var.environment}",
    "SERVER_NAME=web_server_${var.environment}",
    "DATABASE_HOST=${var.db_host}",
    "DATABASE_PORT=${var.db_port}",
    "DATABASE_PASSWORD=${var.db_password}",
  ]

  # Custom HTML page with application information
  upload {
    content = templatefile("${path.root}/index.html.tpl", {
      db_host       = var.db_host
      db_port       = var.db_port
      environment   = var.environment
    })
    file = "/usr/share/nginx/html/index.html"
  }

  # Required to prevent recreation of the container on every plan/apply
  lifecycle {
    ignore_changes = [
      ulimit
    ]
  }
}
EOF

# Create outputs.tf for the nginx module
cat <<'EOF' > ~/modules/project/solution-2/modules/nginx_container/outputs.tf
output "container_id" {
  description = "ID of the nginx container"
  value       = docker_container.nginx_container.id
}

output "container_name" {
  description = "Name of the nginx container"
  value       = docker_container.nginx_container.name
}
EOF

# Create variables.tf for the database module
cat <<'EOF' > ~/modules/project/solution-2/modules/database_container/variables.tf
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
cat <<'EOF' > ~/modules/project/solution-2/modules/database_container/main.tf
# Database container module - main.tf
# Defines MySQL container with environment configuration

resource "docker_image" "database_image" {
  name = var.image_name
}

resource "docker_container" "database_container" {
  name  = var.container_name
  image = docker_image.database_image.name

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
cat <<'EOF' > ~/modules/project/solution-2/modules/database_container/outputs.tf
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
  sensitive   = true
}
EOF

echo "Solution-2 structure created successfully!"
