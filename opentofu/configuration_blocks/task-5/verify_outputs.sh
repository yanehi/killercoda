#!/bin/bash

# Create solution directory
mkdir -p ~/configuration_blocks/syntax-and-configuration/solution-5

# Create provider.tf file
cat > ~/configuration_blocks/syntax-and-configuration/solution-5/provider.tf << 'EOF'
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
cat > ~/configuration_blocks/syntax-and-configuration/solution-5/main.tf << 'EOF'
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
cat > ~/configuration_blocks/syntax-and-configuration/solution-5/variables.tf << 'EOF'
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
cat > ~/configuration_blocks/syntax-and-configuration/solution-5/locals.tf << 'EOF'
locals {
  pid_mode              = "host"
  container_file_path   = "/usr/share/nginx/html/index.html"
  docker_registry_image = "docker.io/library/${var.image_version}"
  internal_port         = 80
}
EOF

# Create output file
cat > ~/configuration_blocks/syntax-and-configuration/solution-5/output.tf << 'EOF'
output "container_id" {
  description = "The ID of the Docker container created by this configuration"
  value       = docker_container.web_server.id
}

output "container_url" {
  description = "The URL of the Docker container created by this configuration"
  value       = "localhost:${var.external_port}"
}

output "container_image" {
  description = "The image used for the Docker container"
  value       = docker_container.web_server.image
}
EOF

echo "solution-5 created successfully!"


