#!/bin/bash

# Create provider.tf file
cat <<'EOF' > ~/modules/task-2/provider.tf
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
cat <<'EOF' > ~/modules/task-2/main.tf
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

echo "Task-2 structure created successfully!"