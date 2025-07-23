# Task 1: Introduction to Modules and Folder Structure

In this task, you will:
- Learn what modules and their benefits are
- See a recommended folder structure for modules
- Create a reusable nginx_container module that includes a Docker image, container, and network
- Reference the module from your root configuration

## Foreword
In Terraform/OpenTofu, a module is a directory that contains configuration files defining a reusable set of infrastructure components.
Modules help structure your code more effectively, promote consistency, and reduce duplication by allowing you to reuse the same configuration across multiple environments or projects.

A module typically groups together logically related resources. For example, a module for a web server might include the server instance, its networking configuration, and associated security settings. By packaging these resources into a module, they can be provisioned and managed as a single, cohesive unit, improving the modularity and maintainability of your infrastructure.

To make a module configurable, you define input variables using variable blocks within the module. These allow users to pass in values such as instance size, region, or image. Any variable that lacks a default value becomes a required input when the module is used.

If you need to expose values from within the module — for instance, an IP address or resource ID — you can define output blocks. These outputs can then be accessed by the root module or by other modules that consume the one you've defined.

## Steps
1. Create a folder structure like this:
   ```plaintext
   root/
     main.tf
     modules/
       nginx_container/
         main.tf
         variables.tf
         outputs.tf
   ```
2. In `modules/nginx_container/main.tf`, define the following resources:
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

**Afterword:**
Grouping related resources in a module makes your code more reusable and easier to manage. You can now use this module in any environment or project that needs an nginx container with its own network. 