#!/bin/bash

# Create provider.tf file
cat <<'EOF' > ~/environments/task-1/provider.tf
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

# Create main.tf file
cat <<'EOF' > ~/environments/task-1/main.tf
# Create a custom Docker network for the application
resource "docker_network" "app_network" {
  name   = "webapp-network-dev" # TODO: Replace with variable
  driver = "bridge"

  ipam_config {
    subnet = "172.20.0.0/16" # TODO: Replace with variable
  }
}

# Create a docker image for the database
resource "docker_image" "database_image" {
  name = "mysql:8.0"
}

# Create a docker image for a ngnix container
resource "docker_image" "nginx_image" {
  name = "nginx:alpine" # TODO: Replace with variable
}


# Create a docker container hosting database
resource "docker_container" "database_container" {
  name  = "webapp-database-dev" # TODO: Replace with variable
  image = docker_image.database_image.image_id

  restart = "unless-stopped"

  # Database environment variables
  env = [
    "MYSQL_ROOT_PASSWORD=secure_password_123", # TODO: Replace with variable
    "MYSQL_DATABASE=webapp_db_dev",            # TODO: Replace with variable
    "MYSQL_USER=webapp_user_dev",              # TODO: Replace with variable
    "MYSQL_PASSWORD=secure_password_123"       # TODO: Replace with variable
  ]

  # Expose database port
  ports {
    internal = 3306 # TODO: Replace with variable
    external = 3306 # TODO: Replace with variable
  }

  # Connect to custom network
  networks_advanced {
    name = docker_network.app_network.name
  }

  # Health check to ensure database is ready
  healthcheck {
    test         = ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-psecure_password_123"] # TODO: Replace with variable
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
  name  = "webapp-nginx-dev" # TODO: Replace with variable
  image = docker_image.nginx_image.image_id

  restart = "unless-stopped"

  # Expose web server port
  ports {
    internal = 80
    external = 8080 # TODO: Replace with variable
  }

  # Connect to custom network
  networks_advanced {
    name = docker_network.app_network.name
  }

  # Environment variables for database connection
  env = [
    "DB_HOST=webapp-database-dev", # TODO: Replace with variable
    "DB_NAME=webapp_db_dev",       # TODO: Replace with variable
    "DB_USER=webapp_user_dev",     # TODO: Replace with variable
    "ENVIRONMENT=dev"              # TODO: Replace with variable
  ]

  # Custom HTML page with application information
  upload {
    content = templatefile("${path.root}/index.html.tpl", {
      db_host        = "webapp-database-dev" # TODO: Replace with variable
      db_name        = "webapp_db_dev" # TODO: Replace with variable
      db_port        = 3306 # TODO: Replace with variable
      network_name   = "webapp-network-dev" # TODO: Replace with variable
      external_port  = 8080 # TODO: Replace with variable
      environment    = "dev" # TODO: Replace with variable
      app_url        = "http://localhost:8080" # TODO: Replace with variable
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

# Create index.html.tpl file
cat <<'EOF' > ~/environments/task-1/index.html.tpl
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

echo "Task-1 successfully created"

