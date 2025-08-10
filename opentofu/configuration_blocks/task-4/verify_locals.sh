#!/bin/bash

# Create solution directory
mkdir -p ~/configuration_blocks/syntax-and-configuration/solution-4

# Create provider.tf file
cat > ~/configuration_blocks/syntax-and-configuration/solution-4/provider.tf << 'EOF'
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}
EOF

# Create main.tf file with variable references
cat > ~/configuration_blocks/syntax-and-configuration/solution-4/main.tf << 'EOF'
resource "docker_image" "nginx" {
  name = local.docker_registry_image
}

# Start a container
resource "docker_container" "web_server" {
  name  = var.web_server_name
  image = docker_image.nginx.name

  pid_mode = local.pid_mode

  ports {
    internal = local.internal_port
    external = var.external_port
  }

  upload {
    content = <<-EOT
      <!DOCTYPE html>
      <html>
      <head>
          <title>My Custom Nginx</title>
      </head>
      <body>
          <h1> ${var.task_number} Configuration blocks </h1>
          <p> ${var.web_server_message} </p>
      </body>
      </html>
    EOT
    file    = local.container_file_path
  }

  lifecycle {
    ignore_changes = [ulimit]
  }
}
EOF

# Create variables file
cat > ~/configuration_blocks/syntax-and-configuration/solution-4/variables.tf << 'EOF'
variable "image_version" {
  description = "The nginx version of the image to use for the container"
  type        = string
  default     = "nginx:latest"
}

variable "web_server_name" {
  description = "The name of the Docker container to be created"
  default     = "web-server"
  type        = string
}

variable "external_port" {
  description = "The external port to expose for the nginx container"
  type        = number
}

variable "task_number" {
  description = "The task number to be included in the HTML content served by the nginx container"
  type        = string
  default     = "Task 2"
}

variable "web_server_message" {
  description = "The message to be displayed by the nginx web server"
  type        = string
  default     = "Hello Terraform! This is a custom message privided through a OpenTofu variable default."
}
EOF

# Create locals file
cat > ~/configuration_blocks/syntax-and-configuration/solution-4/locals.tf << 'EOF'
locals {
  pid_mode              = "host"
  container_file_path   = "/usr/share/nginx/html/index.html"
  docker_registry_image = "docker.io/library/${var.image_version}"
  internal_port         = 80
}
EOF

echo "solution-4 created successfully!"


