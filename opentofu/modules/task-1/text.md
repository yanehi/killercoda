## Foreword
Modules represents a group of related resources into a reusable unit. Think of a module as a “blueprint” for a specific part of your infrastructure. Instead of copying and pasting the same code, you define it once in a module and use it wherever you need.
A typical OpenTofu module is simply a folder containing one or more configuration files (ending in .tf or .tofu). [OpenTofu recommends the following folder structure](https://opentofu.org/docs/language/modules/develop/structure/#:~:text=The%20standard%20module%20structure%20is,the%20module%20registry%2C%20and%20more.) when defining an own module:

```plaintext
my_module/
├── main.tf
├── variables.tf
└── outputs.tf
```
- **main.tf**: Defines the actual resources (like servers, networks, databases) that the module manages.
- **variables.tf**: Represents the input parameters that let you customize how the module works each time you use it.
- **outputs.tf**: Information the module gives back after it runs, which you can use elsewhere in your configuration.





## Task
Create a reusable module for a nginx container that includes a Docker image and container resources. 
1. Start by creating the following folder structure:
```plaintext
modules/ngnix_container/
├── main.tf
├── variables.tf
└── outputs.tf
```
2. In the `modules/nginx_container/variables.tf`, the input parameters should be defined by creating `variables` for:
   - **image_name** for the image name
   - **container_name** for the container name
3. In `modules/nginx_container/main.tf`, define the following resources from the [Kreuzberg provider](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs):
   - **docker_image** resource for the nginx image using the `image_name` variable
   - **docker_container** resource that uses the image and the `container_name` variable. Ensure to expose port 80.
4. In your root `main.tf`, use the module:
   ```hcl
   module "nginx_latest" {
     source       = "./modules/nginx_container"
     image_name   = "nginx:latest"
     container_name = "my-nginx"
   }
   ```
5. Run `tofu init`, `tofu fmt -recursive`, `tofu validate` and `tofu apply` to provision the container and image via the module.


## Afterword:
Grouping related resources in a module makes your code more reusable and easier to manage. You can now use this module in any environment or project that needs an nginx container. 

📝 **Fun Fact:** We already encountered a module in the previous scenario. The folder in which we created the first Terraform/OpenTofu files is considered a module and termed the "root module".
