#!/bin/bash

mkdir -p ~/environments/task-2/dev

# Create provider.tf file
cat <<'EOF' > ~/environments/task-2/dev/provider.tf
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
cat <<'EOF' > ~/environments/task-2/dev/main.tf
# Create a custom Docker network for the application
resource "docker_network" "app_network" {
  name   = "webapp-network-dev" # TODO: Replace with locals
  driver = "bridge"

  ipam_config {
    subnet = "172.20.0.0/16" # TODO: Replace with locals
  }
}

# Create a docker image for the database
resource "docker_image" "database_image" {
  name = "mysql:8.0"
}

# Create a docker image for a ngnix container
resource "docker_image" "nginx_image" {
  name = "nginx:alpine" # TODO: Replace with locals
}


# Create a docker container hosting database
resource "docker_container" "database_container" {
  name  = "webapp-database-dev" # TODO: Replace with locals
  image = docker_image.database_image.image_id

  restart = "unless-stopped"

  # Database environment variables
  env = [
    "MYSQL_ROOT_PASSWORD=secure_password_123", # TODO: Replace with locals
    "MYSQL_DATABASE=webapp_db_dev",            # TODO: Replace with locals
    "MYSQL_USER=webapp_user_dev",              # TODO: Replace with locals
    "MYSQL_PASSWORD=secure_password_123"       # TODO: Replace with locals
  ]

  # Expose database port
  ports {
    internal = 3306 # TODO: Replace with locals
    external = 3306 # TODO: Replace with locals
  }

  # Connect to custom network
  networks_advanced {
    name = docker_network.app_network.name
  }

  # Health check to ensure database is ready
  healthcheck {
    test         = ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-psecure_password_123"] # TODO: Replace with locals
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
  name  = "webapp-nginx-dev" # TODO: Replace with locals
  image = docker_image.nginx_image.image_id

  restart = "unless-stopped"

  # Expose web server port
  ports {
    internal = 80
    external = 8080 # TODO: Replace with locals
  }

  # Connect to custom network
  networks_advanced {
    name = docker_network.app_network.name
  }

  # Upload custom index.html from template
  upload {
    file = "/usr/share/nginx/html/index.html"
    content = templatefile("${path.root}/index.html.tpl", {
      db_host       = "webapp-database-dev"   # TODO: Replace with locals
      db_name       = "webapp_db_dev"         # TODO: Replace with locals
      db_port       = 3306                    # TODO: Replace with locals
      network_name  = "webapp-network-dev"    # TODO: Replace with locals
      external_port = 8080                    # TODO: Replace with locals
      environment   = "dev"                   # TODO: Replace with locals
      app_url       = "http://localhost:8080" # TODO: Replace with locals
    })
  }

  depends_on = [docker_container.database_container]
}
EOF

# Create index.html.tpl template
cat <<'EOF' > ~/environments/task-2/dev/index.html.tpl
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
            <strong>✓ Application Successfully Deployed</strong><br>
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

echo "Task-2 dev environment setup completed successfully!"
