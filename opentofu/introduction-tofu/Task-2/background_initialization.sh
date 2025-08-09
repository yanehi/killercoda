#!/bin/bash

# Create the directory structure if it doesn't exist
mkdir -p ~/introduction-tofu/lifecycle-management

# Create main.tf for the module
cat <<'EOF' > ~/introduction-tofu/lifecycle-management/main.tf
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

resource "docker_container" "web_server" {
  name  = "web-server"
  image = "nginx:latest"

  ports {
    internal = 80
    external = 80
  }

  # Loads a html content into the web_server
  upload {
    content = <<-EOT
      <!DOCTYPE html>
      <html>
      <head>
          <title>My Custom Nginx</title>
      </head>
      <body>
          <h1>This webserver was created via the OpenTofu CLI </h1>
          <p>This custom page is served by your nginx container.</p>
      </body>
      </html>
    EOT
    file    = "/usr/share/nginx/html/index.html"
  }
}
EOF