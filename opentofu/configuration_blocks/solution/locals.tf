locals {
  pid_mode              = "private"
  container_file_path   = "/usr/share/nginx/html/index.html"
  docker_registry_image = "docker.io/library/${var.image_name}"
  internal_port         = 80
}