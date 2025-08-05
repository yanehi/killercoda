variable "image_name" {
  description = "Name of the Docker image"
  type        = string
}

variable "container_name" {
  description = "Name of the Docker container"
  type        = string
}

variable "port" {
  description = "Port to expose for the nginx container"
  type        = number
  default     = 80
}

# DB information to be provid as environment variables to the container
variable "db_container_id" {
  description = "DB container id to be included as environment variables to pass to the nginx container"
  type        = string
}

variable "db_host" {
  description = "DB host to be included as environment variables to pass to the nginx container"
  type        = string
}

variable "db_port" {
  description = "DB port to be included as environment variables to pass to the nginx container"
  type        = string
}

variable "db_password" {
  description = "DB password to be included as environment variables to pass to the nginx container"
  type        = string
  sensitive   = true
}

