#!/bin/bash

# Create solution directory
mkdir -p ~/configuration_blocks/syntax-and-configuration/solution-2

# Create provider.tf file with the required content
cat > ~/configuration_blocks/syntax-and-configuration/solution-2/provider.tf << 'EOF'
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}
EOF

# Create main.tf file with the required content
cat > ~/configuration_blocks/syntax-and-configuration/solution-2/main.tf << 'EOF'
resource "docker_image" "nginx" {
  name = "docker.io/library/nginx:latest"
}

# Start a container
resource "docker_container" "web_server" {
  name  = "web-server"
  image = docker_image.nginx.name

  pid_mode = "private"

  ports {
    internal = 80
    external = 80
  }

  upload {
    content = <<-EOT
      <!DOCTYPE html>
      <html>
      <head>
          <title>My Custom Nginx</title>
      </head>
      <body>
          <h1> Task 2: Configuration blocks </h1>
          <p> The web server was successfully configured with Open Tofu. </p>
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

echo "Solution-2 created successfully!"

