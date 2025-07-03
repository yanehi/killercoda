# Task 3: Variables, Locals, and Outputs
In this task, you will:
- Learn how to define and use variables in Terraform/OpenTofu
- Learn how to define and use locals for intermediate values
- Learn how to define and use output blocks
- Use variables, locals, and outputs in resource definitions
- Format, validate, and apply your configuration

## Foreword
Variables, locals, and outputs help make your Terraform/OpenTofu configurations flexible, reusable, and easy to manage.

- `variable` blocks let you pass values from outside your configuration scripts. Each block defines one variable that you can use in multiple places, as long as the type matches. You can set default values, add descriptions, and override them at runtime. This makes your configuration more flexible and customizable. If a variable block does not have a default value, Terraform/OpenTofu will ask you to provide a value when you run commands.

- `locals` blocks let you define one or more local values (key-value pairs) that you can use throughout your configuration. Locals are useful for simplifying complex expressions, avoiding repetition, and making your code easier to read. Locals are always set within the configuration and cannot be changed from outside.

- `output` blocks let you display or export values from your configuration after applying changes. Outputs are useful for showing important information, passing values to other configurations, or for debugging.

## Steps
1. Add the following to your `main.tf`:
   ```hcl
   variable "container_name" {
     description = "The name of the Docker container."
     type        = string
     default     = "v3rY_uNpLe4s4nt_n4m3"
   }

   locals {
     container_image = "nginx:latest"
   }

   output "container_name" {
     description = "The name of the Docker container used."
     value       = var.container_name
   }

   output "container_image" {
     description = "The Docker image used for the container."
     value       = local.container_image
   }
   ```
2. Update your `docker_image` and `docker_container` resources to use the new variable and local values:
   - The Docker image name should use `local.container_image`.
   - The Docker container name should use `var.container_name`.
3. Run `tofu fmt` to format your code.
4. Run `tofu validate` to check for errors.
5. Run `tofu plan` to see what changes will be made. The container name should match the default value from your variable block.
6. Run `tofu apply` to create or update your resources.
7. View the outputs using:
   ```sh
   tofu output
   ```
   - This will display the values of your output blocks.
8. (Optional) Try changing the value of the `container_name` variable by running:
   - `tofu plan -var 'container_name=<your-container-name>'`
   - `tofu apply -var 'container_name=<your-container-name>'`
   - This lets you see how variables and outputs make your configuration flexible.

**Note:** Variables can be set using CLI flags, environment variables, or `.tfvars` files. Locals are always set inside your configuration and cannot be changed from outside. Outputs are shown after `tofu apply` and can be used by other configurations or scripts.

## Afterword
Variables, locals, and outputs help you write cleaner, more flexible, and more maintainable infrastructure code. Use variables for values you want to change from outside, locals for values or expressions you want to reuse within your configuration, and outputs to display or export important information. Note that we will talk about these concepts again in the context of Terraform/OpenTofu modules.