# Task 2: Managing Resources
In this task, you will:
- Define a Docker image resource (e.g., nginx)
- Define a Docker container resource using the image
- Plan and apply your configuration

## Foreword
In Terraform, a resource is the basic building block used to define infrastructure components. Resources represent physical or virtual elements such as servers, databases, networks, or cloud services. Each resource is declared using the `ressource` block, specifying the **resource type**, a **name**, and its **configuration arguments**. 

For the following task a `nginx` docker image shall be created that will be referenced in the docker container ressource. References between resources are made via the resource type and the resource name following the specific parameter that needs to be referenced.

## Steps
1. Add the following to your `main.tf`:
   ```hcl
   resource "docker_image" "nginx" {
     name = "nginx:latest"
   }
   
   resource "docker_container" "nginx" {
     image = docker_image.nginx.image_id
     name  = "tutorial-nginx"
     ports {
       internal = 80
       external = 8080
     }
   }
   ```
2. Run `tofu fmt` to format your code.
3. Run `tofu validate` to check for errors.
4. Run `tofu plan` to see what will be created.
5. Run `tofu apply` to create the resources.
6. Check running containers with `docker ps`.

**Note:** You can access nginx at `http://localhost:8080` if ports are mapped. 

## Afterword
The `tofu` commands used until now are part of the lifecycle management for the infrastructure. In this task infrastructure resources were created the first time, hence the `tofu plan` as well as `tofu apply` indicate only creation of ressources. Changing ressources or deleting old once as well as the lifecyclemanagement will be part of one of the next tasks. 
