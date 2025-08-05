# Database variables
variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "webapp_db"
}

variable "db_user" {
  description = "Database user name"
  type        = string
  default     = "webapp_user"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "secure_password_123"
  sensitive   = true
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "container_name" {
  description = "Name of the database container"
  type        = string
  default     = "webapp-database"
}

# Web server variables
variable "image_name" {
  description = "Docker image name for the web server"
  type        = string
  default     = "nginx:alpine"
}

variable "web_container_name" {
  description = "Name of the web server container"
  type        = string
  default     = "webapp-nginx"
}

variable "web_external_port" {
  description = "External port for the web server"
  type        = number
  default     = 8080
}

# Network variables
variable "network_name" {
  description = "Docker network name"
  type        = string
  default     = "webapp-network"
}

variable "network_subnet" {
  description = "Network subnet"
  type        = string
  default     = "172.20.0.0/16"
}
