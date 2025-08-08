#!/bin/bash

# Create provider.tf file
cat <<'EOF' >  ~/modules/solution-1/provider.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}
EOF

# Create provider.tf file
cat <<'EOF' >  ~/modules/solution-1/main.tf
module "nginx_latest" {
  source       = "./modules/nginx_container"
  image_name   = "nginx:latest"
  container_name = "my-nginx"
}
EOF


# Create index.html for the nginx container
cat <<'EOF' >  ~/modules/solution-1/modules/nginx_container/index.html
<!DOCTYPE html>
<html>
<head>
    <title>My Custom Nginx Module</title>
</head>
<body>
    <h1>Congratulations! You have successfully created your first Tofu module!</h1>
    <p>This custom page is served by your nginx container module.</p>
</body>
</html>
EOF

# Create variables.tf for the module
cat <<'EOF' >  ~/modules/solution-1/modules/nginx_container/variables.tf
variable "image_name" {
  description = "Name of the Docker image"
  type        = string
}

variable "container_name" {
  description = "Name of the Docker container"
  type        = string
}
EOF

# Create main.tf for the module
cat <<'EOF' >  ~/modules/solution-1/modules/nginx_container/main.tf
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "nginx_image" {
  name = var.image_name
}

resource "docker_container" "nginx_container" {
  name  = var.container_name
  image = docker_image.nginx_image.image_id

  ports {
    internal = 80
    external = 80
  }

  # Referenzierung der index.html aus dem aktuellen Modul-Verzeichnis
  upload {
    content = file("${path.module}/index.html") # Pfad zum aktuellen Modul-Verzeichnis
    file    = "/usr/share/nginx/html/index.html"
  }
}
EOF
echo "Solution-1 structure created successfully!"