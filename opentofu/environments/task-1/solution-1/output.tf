# Output important information
output "application_url" {
  description = "URL to access the web application"
  value       = "http://localhost:${var.web_external_port}"
}

output "database_connection" {
  description = "Database connection information"
  value = {
    host     = docker_container.database_container.name
    port     = var.db_port
    database = var.db_name
    user     = var.db_user
  }
  sensitive = false
}

output "network_info" {
  description = "Network configuration"
  value = {
    network_name = docker_network.app_network.name
    subnet       = var.network_subnet
  }
}

output "containers" {
  description = "Container information"
  value = {
    database = {
      name = docker_container.database_container.name
      ip   = docker_container.database_container.network_data[0].ip_address
    }
    webserver = {
      name = docker_container.nginx_container.name
      ip   = docker_container.nginx_container.network_data[0].ip_address
    }
  }
}