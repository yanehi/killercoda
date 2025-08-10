## What are Locals?
[Local values](https://opentofu.org/docs/language/values/locals/) are a type of configuration block in OpenTofu that allow you to assign a name to an expression. This makes configurations easier to read and maintain by avoiding repetition of complex expressions and providing meaningful names for calculated values.

The following code shows an example of local values definition in OpenTofu and how to reference them with `local.<name>` accross the configuration:
```hcl
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    Owner       = "DevOps Team"
  }

  resource "aws_instance" "web" {
    instance_type = var.instance_type
    ami           = "ami-12345678"

    tags = local.common_tags

    root_block_device {
      volume_size = local.storage_size
    }
  }
}
```

> [!IMPORTANT]  
> Unlike variables, local values cannot be set from outside the configuration. They are calculated within the configuration itself.
> When you ask yourself whether to move values to a local or a variable, consider the following, think about if the value should be configurable from outside the configuration. Then use a variable, otherwise use a local value.
> For when to set your values as locals or to use variables, refer to the [OpenTofu documentation](https://opentofu.org/docs/language/values/locals/#when-to-use-locals).

## Task

In this task, you will learn how to use local values to make your OpenTofu configuration more organized and maintainable. You'll refactor hardcoded values into locals and modify your variable structure to work with locals.

**Goal**: Move hardcoded values to local values and refactor the image variable to work with a local registry prefix.

### Prerequisites
Make sure you have completed the previous tasks and have a working configuration with variables in your `~/configuration_blocks/syntax-and-configuration` directory.

### Steps

1. **Navigate to the working directory** and examine the current configuration:
    ```shell
    cd ~/configuration_blocks/syntax-and-configuration
    ```{{exec}}
    
    Take a look at your current `main.tf` file. You'll notice several hardcoded values that could be moved to locals.

2. **Create a locals.tf file**:
    Create a new file called `locals.tf` in the same directory. This file will contain all your local value definitions. Make sure to create the block `locals{}` and to put the values within the brackets.

3. **Define the required local values**:
    Create local value definitions for the following hardcoded values in your configuration:

    **Local 1: PID Mode**
    - Local name: `pid_mode`
    - Value: `"private"`

    **Local 2: Container File Path**
    - Local name: `container_file_path`
    - Value: `"/usr/share/nginx/html/index.html"`

    **Local 3: Docker Registry Image**
    - Local name: `docker_registry_image`
    - Value: `"docker.io/library/${var.image_name}"` (You can also use variables in your locals, instead of just static parameters)
    - This combines the registry prefix with the variable

    **Local 4: Internal Port**
    - Local name: `internal_port`
    - Value: `80`

4. **Update your variables.tf file**:
    Modify the `image_version` variable to work with a new default:
    - Default value: `"nginx:latest"` (previously `"docker.io/library/nginx:latest"`)
    
    Remove the `docker.io/library/` prefix since this will now be handled by the local value.

5. **Update your main.tf file**:
    Replace the hardcoded values in your `main.tf` file with the appropriate local value references using the `local.<name>` syntax:
    - Replace the hardcoded image reference with `local.docker_registry_image`
    - Replace the hardcoded PID mode with `local.pid_mode`
    - Replace the hardcoded internal port with `local.internal_port`
    - Replace the hardcoded file path with `local.container_file_path`

6. **Validate your configuration**:
    ```shell
    tofu validate
    ```{{exec}}

7. **Format your configuration**:
    ```shell
    tofu fmt
    ```{{exec}}

8. **Create an execution plan**:
    ```shell
    tofu plan -out=plan.tfplan
    ```{{exec}}
    
    Notice how OpenTofu shows the computed local values.

9. **Apply your configuration**:
    ```shell
    tofu apply plan.tfplan
    ```{{exec}}

10. **Test your web server** by accessing it on port 80 (or the port you configured). The functionality should remain the same, but your code is now better organized.

> [!NOTE]  
> Local values are computed during the planning phase and can reference variables, other locals, and resource attributes.

When you click the `Check` button after completing the exercise, the solution for `task-4` will be generated in the corresponding `~/configuration_blocks/syntax-and-configuration/solution-4` folder.
