## Foreword
Modules in OpenTofu/Terraform become more flexible and reusable when they support configurable parameters through variables. These variables allow users to customize the module's behavior without modifying the module's code directly.

**Default Values for Variables:**
You can provide default values for variables, making them optional during module usage. When a variable has a default value, users don't need to specify it explicitly - the default will be used automatically if no value is provided.

**Example:** If most web applications listen on port 80, you can set this as the default value for a port variable. However, if you later need to deploy a web server on port 8080, you can easily override the default by specifying the new port value when calling the module.

**Module Outputs:**
Modules can also return values through outputs, which makes data from the module available to the root module or other modules. This creates a powerful way to chain modules together and share information between different parts of your infrastructure.


## Task
Create another variable in the `modules/nginx_container/variables.tf` file to be able to adjust the port from outside the modul. Also the ID of the created nginx container should be returned as an output variable.

1. **Add a port variable:** In `modules/nginx_container/variables.tf`, create a new variable named `port` with a default value of `80`.

2. **Update the container configuration:** Reference the `port` variable in the `modules/nginx_container/main.tf` file to set the exposed port of the nginx container dynamically.

3. **Validate your changes:** Run the following commands to ensure everything is configured correctly:
```
tofu fmt -recursive
```{{exec}}

```
tofu validate
```{{exec}}

```
tofu plan
```{{exec}}

```
tofu apply
```{{exec}}

4. **Add an output variable:** Define an output variable in `modules/nginx_container/outputs.tf` to return the container ID of the nginx container from [Kreuzberg](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container#read-only).
5. **Add an output variable:** In your root `option.tf`, add an output block to display the container ID of the nginx container after reference the output of your module. Read more about [https://opentofu.org/docs/language/modules/syntax/#accessing-module-output-values).
6. **Apply your changes:** Run the following command to apply your changes and see the output:

```
tofu fmt -recursive
```{{exec}}

```
tofu validate
```{{exec}}

```
tofu plan
```{{exec}}

```
tofu apply
```{{exec}}


