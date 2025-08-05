# Database container module - outputs.tf
# Output values from the database container module

output "container_id" {
  description = "ID of the database container"
  value       = docker_container.database_container.id
}

output "container_name" {
  description = "Name of the database container"
  value       = docker_container.database_container.name
}

output "db_port" {
  description = "Port exposed by the database container"
  value       = var.db_port
}

output "db_password" {
  description = "Password exposed by the database container"
  value       = var.db_password
}
