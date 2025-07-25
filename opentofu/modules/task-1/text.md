# Task 1: Introduction to Modules and Folder Structure

## Foreword
In this task, you will:
- Learn what modules and their benefits are
- See a recommended folder structure for modules
- Create a reusable nginx_container module that includes a Docker image, container, and network
- Reference the module from your root configuration

## What is a Module?
In Terraform/OpenTofu, a modul acts as a container for a set of resources that are logically grouped together. This allows you to encapsulate and reuse configurations, making your infrastructure code more modular and maintainable.
The Terraform/OpenTofu module is a directory consisting of a collection of `*.tf` or `*.tofu` files which defines the module. In general modules consists of:
- **Resources**: The actual infrastructure components, such as virtual machines, networks, or databases.
- **Variables**: Input parameters that allow you to customize the module's behavior without changing its code.
- **Outputs**: Values that the module can return, which can be used by other modules or the root configuration.

After defining a module, you can use it in your root configuration or other modules by referencing its source path. This promotes code reuse and helps maintain a clean and organized codebase.
### Module instantiation example
```hcl
   module "module_name" {
     source       = "<relative path to the module ressources>"
     variable_parameter1 = "value1"
     variable_parameter2 = "value2"
     variable_parameter3 = "value3"
   }
   ```


## Task
We want to create a reusable module for a nginx container that includes a Docker image, container, and network. This module will allow us to easily deploy a nginx container with its own network in any environment.
1.  First create module subdirectory where all modules will be defined. The folger structure should look like this:
   ```shell
     # Create the folder structure
     mkdir -p modules/nginx_container
     
     # Create the module files
     touch main.tf
     touch modules/nginx_container/main.tf
     touch modules/nginx_container/variables.tf
     touch modules/nginx_container/outputs.tf
     
     # Show the folder structure
     ls -laR
   ```   

2. In `modules/nginx_container/main.tf`, define the following resources from [Kreuzberg Provider](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs):
   - A `docker_network` resource for the container's network
   - A `docker_image` resource for the nginx image
   - A `docker_container` resource that uses the image and network
3. In `modules/nginx_container/variables.tf`, define variables for image name, container name, and network name. 
4. In `modules/nginx_container/outputs.tf`, output the container ID and network name.
5. In your root `main.tf`, use the module:
   ```hcl
   module "nginx" {
     source       = "./modules/nginx_container"
     image        = "nginx:latest"
     container_name = "my-nginx"
     network_name = "nginx-net"
   }
   ```
6. Run `tofu init`, `tofu fmt -recursive`, `tofu validate` and `tofu apply` to provision the container, image, and network via the module.

## Afterword:
Grouping related resources in a module makes your code more reusable and easier to manage. You can now use this module in any environment or project that needs an nginx container with its own network. 

📝 **Fun Fact:** We already encountered a module in the previous scenario. The folder in which we created the first Terraform/OpenTofu files is considered a module and termed the "root module".
