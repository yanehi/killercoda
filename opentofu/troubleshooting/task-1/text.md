# Variables and locals


In this exercise, the focus is on dealing with variables and locals in terraform. Fix the errors in the code and create any missing resources.

## Notes

- Check the comments in the *.tf files
- Check the output of the `tofu apply` command if your values are set right

## Files

locals.tf
```hcl
locals {
  # Set the value for the alpine_image_name variable
  # The value represents the name of the docker registry: https://hub.docker.com/_/nginx

  # Set the value for the nginx_image_name variable
  # The value represents the name of the docker registry: https://hub.docker.com/_/alpine


  # Set the value for the alpine_container_name and nginx_container_name variable
  # The value is a concatenated string of "topic4-<alpine|nginx>-" and the value of the "environment" variable

}
```

main.tf
```hcl
resource "docker_image" "nginx" {
  # Use the value from the locals and variables
  name = ""
}


resource "docker_image" "alpine" {
  name = "${var.alpine_image_name}:local.alpine_image_tag"
}


resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  # Use the value of the nginx_container_name variable
  name  = ""
  ports {
    internal = 80
    external = 8080
  }
}


resource "docker_container" "alpine" {
  image = docker_image.alpine.name
  name  = var.alpine_container_name

  # Keep the container running
  command = ["tail", "-f", "/dev/null"]
}
```


variables.tf
```hcl
variable "environment" {
  type        = bool
  description = "Environment to deploy the container (dev, test, prod)"
  default     = 3
}

variable "nginx_image_tag" {
  type        = string
  description = "Image Tag for Nginx"
  default     = 1
}

# Create the missing variable definition for the alpine_image_tag
```


## Test and deploy locally

Validate your code with the following command:

```
tofu validate
```

Create the infrastructure on your local machine:

```
tofu init

tofu apply
```
