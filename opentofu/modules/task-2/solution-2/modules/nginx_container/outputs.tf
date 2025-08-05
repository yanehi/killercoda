output "container_id" {
  description = "ID of the nginx container"
  value       = docker_container.nginx_container.id
}
