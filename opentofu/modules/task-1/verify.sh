#!/bin/bash

mkdir -p ~/modules/project/solution-1/modules/nginx_container

# Create provider.tf file
cat <<'EOF' >  ~/modules/project/solution-1/provider.tf
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

# Create provider.tf file
cat <<'EOF' >  ~/modules/project/solution-1/main.tf
module "web_server_production" {
  source         = "./modules/nginx_container"
  image_name     = "docker.io/library/nginx:latest"
  container_name = "web_server_production"
  external_port  = 80
  environment    = "production"
}

module "web_server_development" {
  source         = "./modules/nginx_container"
  image_name     = "docker.io/library/nginx:1.29.0"
  container_name = "web_server_development"
  external_port  = 8080
  environment    = "development"
}
EOF


# Create index.html.tpl for the nginx container
cat <<'EOF' >  ~/modules/project/solution-1/modules/nginx_container/index.html.tpl
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
            <span>(empty - will be set in Task 2)</span>
        </div>
        <div class="env-item">
            <strong>DATABASE_PORT:</strong>
            <span>(empty - will be set in Task 2)</span>
        </div>
        <div class="env-item">
            <strong>DATABASE_PASSWORD:</strong>
            <span>***** (empty - will be set in Task 2)</span>
        </div>
    </div>
</div>
</body>
</html>
EOF

# Create variables.tf for the module
cat <<'EOF' >  ~/modules/project/solution-1/modules/nginx_container/variables.tf
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

EOF

# Create main.tf for the module
cat <<'EOF' >  ~/modules/project/solution-1/modules/nginx_container/main.tf
# Used to download the nginx image for the web server
resource "docker_image" "web_server" {
  name = var.image_name
}

# Create a web server container
resource "docker_container" "web_server" {
  name     = var.container_name
  image    = docker_image.web_server.name
  pid_mode = "host"

  ports {
    internal = 80
    external = var.external_port
  }

  # Set environment variables
  env = [
    "ENVIRONMENT=${var.environment}",
    "SERVER_NAME=${var.container_name}",
    "DATABASE_HOST=",     # TODO: Replace in Task 2
    "DATABASE_PORT=",     # TODO: Replace in Task 2
    "DATABASE_PASSWORD=", # TODO: Replace in Task 2
  ]

  # Custom HTML page with application information
  upload {
    content = templatefile("${path.root}/index.html.tpl", {
      db_host       = ""
      db_port       = ""
      external_port = ""
      environment   = "${var.environment}"
      app_url       = "localhost:${var.external_port}"
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

# Create provider.tf for the module
cat <<'EOF' >  ~/modules/project/solution-1/modules/nginx_container/provider.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

EOF

echo "Solution-1 structure created successfully!"