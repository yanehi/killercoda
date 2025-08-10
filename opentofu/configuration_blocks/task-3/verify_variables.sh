#!/bin/bash

# Create solution directory
mkdir -p ~/configuration_blocks/syntax-and-configuration/solution-3

# Create provider.tf file
cat > ~/configuration_blocks/syntax-and-configuration/solution-3/provider.tf << 'EOF'
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}
EOF

# Create variables.tf file
cat > ~/configuration_blocks/syntax-and-configuration/solution-3/variables.tf << 'EOF'
variable "image_version" {
  description = "Docker image name and version"
  type        = string
  default     = "docker.io/library/nginx:latest"
}

variable "web_server_name" {
  description = "Name of the web server container"
  type        = string
  default     = "web-server"
}

variable "external_port" {
  description = "External port for the web server"
  type        = number
  default     = 80
}

variable "task_number" {
  description = "Task number to display in the HTML content"
  type        = string
  default     = "Task 3:"
}

variable "web_server_message" {
  description = "Message to display on the web page"
  type        = string
  default     = "The web server was successfully configured with Open Tofu using variables."
}
EOF

# Create main.tf file with variable references
cat > ~/configuration_blocks/syntax-and-configuration/solution-3/main.tf << 'EOF'
resource "docker_image" "nginx" {
  name = var.image_version
}

# Start a container
resource "docker_container" "web_server" {
  name  = var.web_server_name
  image = docker_image.nginx.name

  pid_mode = "private"

  ports {
    internal = 80
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
    file    = "/usr/share/nginx/html/index.html"
  }

  lifecycle {
    ignore_changes = [ulimit]
  }
}
EOF

# Create main.tf file with variables reference
cat > ~/configuration_blocks/syntax-and-configuration/solution-3/variables.tf << 'EOF'
variable "image_version" {
  description = "The nginx version of the image to use for the container"
  type        = string
  default = "docker.io/library/nginx:latest"
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

echo "Solution-3 created successfully!"


