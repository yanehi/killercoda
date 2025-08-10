## What are Outputs?
[Output values](https://opentofu.org/docs/language/values/outputs/) are block types of the OpenTofu configuration language that allow you to export structured data about your resources. 
Output values make information about your infrastructure available for use by other OpenTofu configurations, or they can be used to display useful information in the command line interface.

The following code shows an example of an output value definition in OpenTofu:
```hcl
output "instance_ip_address" {
  description = "The private IP address of the main server instance"
  value       = aws_instance.main.private_ip
  sensitive   = false
  depends_on = [aws_instance.main]
}
```
- **description**: An optional description of the output that explains what the output represents.
- **value**: The value to be returned. This can be a simple value, a resource attribute, or a complex expression.
- **sensitive**: An optional flag that indicates whether the output contains sensitive information. If `true`, the value will be masked in the CLI output.
- **depends_on**: An optional argument that specifies dependencies for the output. This ensures that the output is only computed after the specified resources are created.

To view outputs, you can use the `tofu output` command after applying your configuration:
```shell
tofu output
tofu output instance_ip_address  # View a specific output
```

Output values are displayed automatically when you run `tofu apply` and can be referenced in other configurations using remote state data sources.

> [!IMPORTANT]  
> In the following tasks, only the parameters `description` and `value` will be used.

## Task

In this task, you will learn how to create output values to expose useful information about your infrastructure. You'll create outputs that display important details about your Docker container and make them visible in the command line.

**Goal**: Create output values to display information about your Docker infrastructure after deployment.

### Prerequisites
Make sure you have completed the previous tasks and have a working configuration with variables and locals in your `~/configuration_blocks/syntax-and-configuration` directory.

### Steps

1. **Navigate to the working directory** and examine the current configuration:
    ```shell
    cd ~/configuration_blocks/syntax-and-configuration
    ```{{exec}}

2. **Create an outputs.tf file**:
   Create a new file called `outputs.tf` in the same directory. This file will contain all your output definitions.

3. **Define the required outputs**:
   Create output definitions for the following information about your infrastructure:

   **Output 1: Container ID**
    - Output name: `container_id`
    - Description: "The ID of the Docker container created by this configuration"
    - Value: The ID attribute of your Docker container resource

   **Output 2: Container URL**
    - Output name: `container_url`
    - Description: "The URL to access the web server"
    - Value: A formatted string showing "http://localhost:" followed by the external port variable

   **Output 3: Container Image**
    - Output name: `container_image`
    - Description: "The image used for the Docker container"
    - Value: The image attribute of your Docker container resource

   **Output 4: Container Name**
    - Output name: `container_name`
    - Description: "The name of the Docker container"
    - Value: The name attribute of your Docker container resource

4. **Validate your configuration**:
    ```shell
    tofu validate
    ```{{exec}}

5. **Format your configuration**:
    ```shell
    tofu fmt
    ```{{exec}}

6. **Create an execution plan**:
    ```shell
    tofu plan -out=plan.tfplan
    ```{{exec}}
    
    Notice how OpenTofu shows the outputs that will be generated.

7. **Apply your configuration**:
    ```shell
    tofu apply plan.tfplan
    ```{{exec}}
    
    After applying, you should see the output values displayed automatically in the console.

8. **View all outputs**:
    ```shell
    tofu output
    ```{{exec}}
    
    This command shows all output values from your configuration.

9. **View a specific output**:
    ```shell
    tofu output container_url
    ```{{exec}}
    
    This shows only the container URL output.

11. **View outputs in JSON format** (Optional):
    ```shell
    tofu output -json
    ```{{exec}}
    
    This displays all outputs in JSON format, useful for automation and scripting.

> [!NOTE]  
> Output values are computed after resources are created and can reference any resource attribute that is known after apply.

When you click the `Check` button after completing the exercise, the solution for `task-5` will be generated in the corresponding `~/configuration_blocks/syntax-and-configuration/solution-5` folder.
