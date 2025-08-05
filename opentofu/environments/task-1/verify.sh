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
# Feature flags for enabling/disabling components
variable "enable_database" {
  description = "Flag to enable/disable database component"
  type        = bool
  default     = true
}

variable "enable_webserver" {
  description = "Flag to enable/disable webserver component"
  type        = bool
  default     = true
}

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

# Create a docker image for a ngnix container
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
    "DB_NAME=${var.db_name}",
    "DB_USER=${var.db_user}",
    "ENVIRONMENT=${var.environment}"
  ]

  # Custom HTML page with application information
  upload {
    content = templatefile("${path.root}/index.html.tpl", {
      db_host       = docker_container.database_container.name
      db_name       = var.db_name
      db_port       = var.db_port
      network_name  = var.network_name
      external_port = var.web_external_port
      environment   = var.environment
      app_url       = var.app_url
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
EOF

# Create output.tf file
cat <<'EOF' > ~/environments/task-1/solution-1/output.tf
# Output important information
output "application_url" {
  description = "URL to access the web application"
  value       = "http://localhost:${docker_container.nginx_container.ports[0].external}"
}

output "database_connection" {
  description = "Database connection information"
  value = {
    host     = docker_container.database_container.name
    port     = docker_container.database_container.ports[0].external
    database = join("", [for env in docker_container.database_container.env : trimprefix(env, "MYSQL_DATABASE=") if can(regex("^MYSQL_DATABASE=", env))])
    user     = join("", [for env in docker_container.database_container.env : trimprefix(env, "MYSQL_USER=") if can(regex("^MYSQL_USER=", env))])
  }
  sensitive = false
}

output "network_info" {
  description = "Network configuration"
  value = {
    network_name = docker_network.app_network.name
    subnet       = docker_network.app_network.ipam_config[0].subnet
  }
}

output "containers" {
  description = "Container information"
  value = {
    database = {
      name = docker_container.database_container.name
      ip   = docker_container.database_container.network_data[0].ip_address
    }
    webserver = {
      name = docker_container.nginx_container.name
      ip   = docker_container.nginx_container.network_data[0].ip_address
    }
  }
}
EOF

# Create dev.tfvars file
cat <<'EOF' > ~/environments/task-1/solution-1/env/dev.tfvars
# Development environment configuration
environment = "dev"
app_url = "http://localhost:8080"

# Database variables
db_name = "webapp_db"
db_user = "webapp_user"
db_password = "secure_password_123"
db_port = 3306
container_name = "webapp-database"

# Web server variables
image_name = "nginx:alpine"
web_container_name = "webapp-nginx"
web_external_port = 8080

# Network variables
network_name = "webapp-network"
network_subnet = "172.20.0.0/16"
EOF

# Create prod.tfvars file
cat <<'EOF' > ~/environments/task-1/solution-1/env/prod.tfvars
# Production environment configuration
environment = "prod"
app_url = "http://localhost:80"

# Database variables
db_name = "webapp_db"
db_user = "webapp_user"
db_password = "secure_password_123"
db_port = 3306
container_name = "webapp-database-prod"

# Web server variables
image_name = "nginx:alpine"
web_container_name = "webapp-nginx-prod"
web_external_port = 80

# Network variables
network_name = "webapp-network-prod"
network_subnet = "172.21.0.0/16"
EOF

# Create index.html.tpl file
cat <<'EOF' > ~/environments/task-1/solution-1/index.html.tpl
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
        .architecture {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }
        .component {
            display: flex;
            align-items: center;
            margin: 10px 0;
            padding: 10px;
            background-color: white;
            border-radius: 5px;
            border-left: 4px solid #3498db;
        }
        .icon {
            font-size: 1.5em;
            margin-right: 10px;
        }
        ul {
            list-style-type: none;
            padding: 0;
        }
        li {
            margin: 8px 0;
            padding: 5px 0;
        }
        .endpoint {
            background-color: #ecf0f1;
            padding: 8px 12px;
            border-radius: 4px;
            margin: 5px 0;
            font-family: monospace;
        }
        .endpoint a {
            color: #2980b9;
            text-decoration: none;
        }
        .endpoint a:hover {
            text-decoration: underline;
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
                    <span>🗄️ Database Host:</span>
                    <span class="highlight">${db_host}</span>
                </div>
                <div class="status">
                    <span>🔗 Network:</span>
                    <span class="success">✅ ${network_name}</span>
                </div>
                <div class="status">
                    <span>📡 External Port:</span>
                    <span class="highlight">${external_port}</span>
                </div>
                <div class="status">
                    <span>🏷️ Environment:</span>
                    <span class="highlight">${upper(environment)}</span>
                </div>
                <div class="status">
                    <span>🔗 Application URL:</span>
                    <span class="highlight"><a href="${app_url}" target="_blank">${app_url}</a></span>
                </div>
            </div>
        </div>

        <div class="architecture">
            <h3>🏗️ Architecture Components</h3>
            <div class="component">
                <div class="icon">🌐</div>
                <div>
                    <strong>Docker Network:</strong> Custom bridge network (${network_name})
                    <br><small>Enables secure communication between containers</small>
                </div>
            </div>
            <div class="component">
                <div class="icon">🗄️</div>
                <div>
                    <strong>MySQL Database:</strong> Version 8.0 with persistent storage
                    <br><small>Host: ${db_host} | Port: ${db_port} | Database: ${db_name}</small>
                </div>
            </div>
            <div class="component">
                <div class="icon">🖥️</div>
                <div>
                    <strong>Nginx Webserver:</strong> Alpine Linux based container
                    <br><small>Running on port 80 (internal) and ${external_port} (external)</small>
                </div>
            </div>
        </div>

        <h3>🔗 Available Endpoints</h3>
        <div class="endpoint">
            <a href="/">GET /</a> - This main page
        </div>
        <div class="endpoint">
            <a href="/health" target="_blank">GET /health</a> - Health Check (would return 404, not configured)
        </div>

        <div class="info-box">
            <h4>💡 Terraform/OpenTofu Learning Objectives</h4>
            <ul>
                <li>✅ <strong>Resource Management:</strong> Docker Images and Containers</li>
                <li>✅ <strong>Network Configuration:</strong> Custom Docker Networks</li>
                <li>✅ <strong>Service Dependencies:</strong> Web server waits for database</li>
                <li>✅ <strong>Variable Usage:</strong> Parameterized configuration</li>
                <li>✅ <strong>Outputs:</strong> Important information for further use</li>
                <li>✅ <strong>Health Checks:</strong> Container health monitoring</li>
                <li>✅ <strong>Volume Mounting:</strong> Persistent data storage</li>
                <li>✅ <strong>Environment Management:</strong> Multi-environment support</li>
            </ul>
        </div>

        <div class="info-box">
            <p><strong>🎯 Note:</strong> This application demonstrates a complete Terraform configuration
            for a multi-container application. The containers are connected via a custom network
            and can communicate with each other.</p>

            <p><strong>🚀 Deployment:</strong> Use <code>tofu init</code>, <code>tofu plan</code> and
            <code>tofu apply -var-file="env/${environment}.tfvars"</code> to deploy this infrastructure.</p>

            <p><strong>🔧 Environment:</strong> Currently running in <strong>${upper(environment)}</strong> mode
            at <a href="${app_url}" class="highlight">${app_url}</a>.
            Switch environments by using different .tfvars files.</p>
        </div>
    </div>
</body>
</html>
EOF

echo "Solution-1 directory structure created successfully!"
