## Foreword
Modules groups related resources into a reusable unit. For example grouping a virtual machine that hosts an application together with a database instance, so that they always be deployed together. 
Instead of copying and pasting the same code, you define it once in a module and configured it with different parameters.

A typical OpenTofu module is simply a folder containing one or more configuration files (ending in `.tf` or `.tofu`). 
[OpenTofu recommends the following folder structure](https://opentofu.org/docs/language/modules/develop/structure/#:~:text=The%20standard%20module%20structure%20is,the%20module%20registry%2C%20and%20more.) when defining an own module:

```plaintext
my_module/
├── main.tf
├── variables.tf
└── outputs.tf
```
- **main.tf**: Defines the actual resources (like servers, networks, databases) that the module manages.
- **variables.tf**: Represents the input parameters that allow you to customise the resource residing inside the module. Late on you will see that every you define within the directory, can be put as an input parameter to the module.
- **outputs.tf**: Exposes values from a module so they can be used by the calling configuration or by other modules.

## Task
# Task 1: Creating Your First OpenTofu Module

## Overview
In this task, you will learn how to create reusable OpenTofu modules by refactoring existing infrastructure code. You'll extract the nginx container configuration from the main configuration into a dedicated module, making it reusable and maintainable.


## Prerequisites
- Basic understanding of OpenTofu resources and variables
- Familiarity with Docker concepts
- Completed the configuration_blocks scenario (recommended)

## Task Description

Currently, your infrastructure code in `main.tf` contains hardcoded values and duplicated patterns for nginx containers. Your goal is to extract the production nginx container configuration into a reusable module that can be parameterized and used across different environments.

### Step 1: Create Module Directory Structure

Create the module directory structure in your project:
    ```shell
    mkdir -p ~/modules/project/modules/nginx_container
    ```{{exec}}

Within the `modules/nginx_container` directory, create the following files:
- `provider.tf` - Provider configuration for the module
- `main.tf` - Main resources for the nginx container
- `variables.tf` - Input variables for the module

### Step 2: Define Module Variables

Create the `variables.tf` file with the following variable definitions:

Based on the existing solution structure, define variables for:
- `image_name` (string) - Docker image name for nginx
- `container_name` (string) - Name of the nginx container  
- `external_port` (number) - External port for nginx
- `environment` (string) - The environment identifier (production, development, etc.)

### Step 3: Extract Resources to Module
Move the `index.html.tpl`file to the module directory:
    ```shell
    mv ~/modules/project/index.html.tpl ~/modules/project/modules/nginx_container/
    ```{{exec}}

Copy the production nginx container resources from your `main.tf` to the module's `main.tf`:
- Move the `docker_image "web_server_prod"` resource
- Move the `docker_container "web_server_production"` resource


### Step 4: Replace Hardcoded Values with Variables

In your module's `main.tf`, do all TODOs (except those marked for Task 2):

- Remove the `_prod` and `_production` suffixes from resource names
- Replace hardcoded container name with `var.container_name`
- Replace hardcoded external port with `var.external_port`
- Replace hardcoded environment values with `var.environment`
- Update the templatefile environment parameter to use `var.environment`
- Update the app_url to use the variable port

> **Important**: Leave DATABASE_HOST, DATABASE_PORT, and DATABASE_PASSWORD TODOs unchanged - these will be addressed in Task 2.

### Step 5: Initialize Modules

Navigate to your root directory (`~/modules/project`):

  ```shell    
  cd ~/modules/project   
  ```{{exec}} 
  
Replace the content of `main.tf` to use the new module:    

```hcl
module "nginx_container" {
  source = "./modules/nginx_container"
  image_name = "nginx:latest"
  container_name = "nginx_container"
  external_port = 80
  environment = "production"
}

module "nginx_container_dev" {
  source = "./modules/nginx_container"
  image_name = "nginx:latest"
  container_name = "nginx_container_dev"
  external_port = 8080
  environment = "development"
}
```

After that initialize the modules:
    ```shell
    tofu init
    ```{{exec}} 

This command will download the required providers and initialize any modules in your configuration.

### Step 6: Validate and Plan

Format your configuration files:
    ```shell
    tofu fmt
    ```{{exec}} 

Validate the configuration:
    ```shell
    tofu validate
    ```{{exec}} 

Create an execution plan:
    ```shell
    tofu plan -out=plan.tfplan
    ```{{exec}} 

Review the plan output to ensure your module configuration will create the expected resources.

### Step 7: Apply Configuration

Execute the plan to create your infrastructure:
    ```shell
    tofu apply plan.tfplan
    ```{{exec}} 


### Step 8: Verify Deployment

Test that your containerized web servers are accessible. Development should be on port 8080 and production on port 80.
![Access web server in Killercoda](./../assets/access_ports_killercoda.png)

Both should return HTML pages showing their respective environment configurations.


When you click the `Check` button after completing the exercise, the solution for `task-1` will be generated in the corresponding `~/modules/project/solution-1` folder.

