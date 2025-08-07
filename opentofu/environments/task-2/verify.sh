#!/bin/bash

# Create solution-2 directory structure
mkdir -p ~/environments/task-2/solution-2/dev
mkdir -p ~/environments/task-2/solution-2/prod

echo "Creating Task-2 solution structure..."

# Create dev environment files
cat <<'EOF' > ~/environments/task-2/solution-2/dev/provider.tf
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

cat <<'EOF' > ~/environments/task-2/solution-2/dev/locals.tf
locals {
  # Network configuration
  network_name   = "webapp-network-dev"
  network_subnet = "172.20.0.0/16"

  # Database configuration
  container_name = "webapp-database-dev"
  db_name        = "webapp_db_dev"
  db_user        = "webapp_user_dev"
  db_password    = "secure_password_123"
  db_port        = 3306

  # Web server configuration
  web_container_name = "webapp-nginx-dev"
  image_name         = "nginx:alpine"
  web_external_port  = 8080

  # Environment configuration
  environment = "dev"
  app_url     = "http://localhost:8080"

  # Batch job configuration (dev-only)
  enable_batch_job     = true
  batch_container_name = "webapp-batch-dev"
  batch_image_name    = "alpine:latest"
}
EOF

cat <<'EOF' > ~/environments/task-2/solution-2/dev/main.tf
# Create a custom Docker network for the application
resource "docker_network" "app_network" {
  name   = local.network_name
  driver = "bridge"

  ipam_config {
    subnet = local.network_subnet
  }
}

# Create a docker image for the database
resource "docker_image" "database_image" {
  name = "mysql:8.0"
}

# Create a docker image for nginx container
resource "docker_image" "nginx_image" {
  name = local.image_name
}

# Create a docker container hosting database
resource "docker_container" "database_container" {
  name  = local.container_name
  image = docker_image.database_image.image_id

  restart = "unless-stopped"

  # Database environment variables
  env = [
    "MYSQL_ROOT_PASSWORD=${local.db_password}",
    "MYSQL_DATABASE=${local.db_name}",
    "MYSQL_USER=${local.db_user}",
    "MYSQL_PASSWORD=${local.db_password}"
  ]

  # Expose database port
  ports {
    internal = local.db_port
    external = local.db_port
  }

  # Connect to custom network
  networks_advanced {
    name = docker_network.app_network.name
  }

  # Health check to ensure database is ready
  healthcheck {
    test         = ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${local.db_password}"]
    interval     = "30s"
    timeout      = "10s"
    retries      = 3
    start_period = "60s"
  }

  # Volume for persistent data storage
  volumes {
    host_path      = "/tmp/mysql_data"
    container_path = "/var/lib/mysql"
  }
}

# Create nginx container for web server
resource "docker_container" "nginx_container" {
  name  = local.web_container_name
  image = docker_image.nginx_image.image_id

  restart = "unless-stopped"

  # Expose web server port
  ports {
    internal = 80
    external = local.web_external_port
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
      db_name       = local.db_name
      db_port       = local.db_port
      network_name  = local.network_name
      external_port = local.web_external_port
      environment   = local.environment
      app_url       = local.app_url
    })
  }

  depends_on = [docker_container.database_container]
}

# Debug container for development (Redis for caching/sessions)
resource "docker_image" "redis_image" {
  name  = "redis:alpine"
}

resource "docker_container" "debug_container" {
  name  = "${local.environment}-debug-redis"
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
EOF

cat <<'EOF' > ~/environments/task-2/solution-2/dev/index.html.tpl
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

cat <<'EOF' > ~/environments/task-2/solution-2/prod/locals.tf
locals {
  # Network configuration
  network_name   = "webapp-network-prod"
  network_subnet = "172.21.0.0/16"

  # Database configuration
  container_name = "webapp-database-prod"
  db_name        = "webapp_db_prod"
  db_user        = "webapp_user_prod"
  db_password    = "zP8~99^1W7zA"
  db_port        = 3307

  # Web server configuration
  web_container_name = "webapp-nginx-prod"
  image_name         = "nginx:latest"
  web_external_port  = 80

  # Environment configuration
  environment = "prod"
  app_url     = "http://localhost:80"

  # Batch job configuration (disabled in prod)
  enable_batch_job     = false
  batch_container_name = "webapp-batch-prod"
  batch_image_name    = "alpine:latest"
}
EOF


cat <<'EOF' > ~/environments/task-2/solution-2/prod/main.tf
# Create a custom Docker network for the application
resource "docker_network" "app_network" {
  name   = local.network_name
  driver = "bridge"

  ipam_config {
    subnet = local.network_subnet
  }
}

# Create a docker image for the database
resource "docker_image" "database_image" {
  name = "mysql:8.0"
}

# Create a docker image for nginx container
resource "docker_image" "nginx_image" {
  name = local.image_name
}

# Create a docker container hosting database
resource "docker_container" "database_container" {
  name  = local.container_name
  image = docker_image.database_image.image_id

  restart = "unless-stopped"

  # Database environment variables
  env = [
    "MYSQL_ROOT_PASSWORD=${local.db_password}",
    "MYSQL_DATABASE=${local.db_name}",
    "MYSQL_USER=${local.db_user}",
    "MYSQL_PASSWORD=${local.db_password}"
  ]

  # Expose database port
  ports {
    internal = local.db_port
    external = local.db_port
  }

  # Connect to custom network
  networks_advanced {
    name = docker_network.app_network.name
  }

  # Health check to ensure database is ready
  healthcheck {
    test         = ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${local.db_password}"]
    interval     = "30s"
    timeout      = "10s"
    retries      = 3
    start_period = "60s"
  }

  # Volume for persistent data storage
  volumes {
    host_path      = "/tmp/mysql_data"
    container_path = "/var/lib/mysql"
  }
}

# Create nginx container for web server
resource "docker_container" "nginx_container" {
  name  = local.web_container_name
  image = docker_image.nginx_image.image_id

  restart = "unless-stopped"

  # Expose web server port
  ports {
    internal = 80
    external = local.web_external_port
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
      db_name       = local.db_name
      db_port       = local.db_port
      network_name  = local.network_name
      external_port = local.web_external_port
      environment   = local.environment
      app_url       = local.app_url
    })
  }

  depends_on = [docker_container.database_container]
}

# Debug container for development (Redis for caching/sessions)
resource "docker_image" "redis_image" {
  name  = "redis:alpine"
}

resource "docker_container" "debug_container" {
  name  = "${local.environment}-debug-redis"
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
resource "docker_container" "backup_container" {
  name  = "${local.environment}-backup-service"
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

cat <<'EOF' > ~/environments/task-2/solution-2/prod/index.html.tpl
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

# Create dev environment files
cat <<'EOF' > ~/environments/task-2/solution-2/prod/provider.tf
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

echo "Task-2 solution successfully created in ~/environments/task-2/solution-2/"
