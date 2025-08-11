# Task 2: Module Integration and Data Flow

## Overview
In this task, you will learn how to connect multiple OpenTofu modules and pass data between them using outputs and inputs. You'll integrate a database module with your existing nginx module, demonstrating how modules can work together to create complex infrastructure.

## Prerequisites
- Completed Task 1 (nginx_container module)
- Understanding of OpenTofu modules, variables, and outputs
- Basic knowledge of database concepts

## Task Description

You will extend your infrastructure by adding a database module and connecting it to your nginx module. The database module will provide connection information (host, port, password) that will be passed to the nginx containers as environment variables.

Currently, your nginx containers show empty values for DATABASE_HOST, DATABASE_PORT, and DATABASE_PASSWORD. Your goal is to fill these values using outputs from a database module.

## Initial Setup

You will find the following resources already prepared for you:

1. **Database Module**: Located in `modules/database_container/` with:
   - `main.tf` - MySQL container resource
   - `variables.tf` - Input variables for database configuration
   - `outputs.tf` - Exports database connection information

2. **Database Configuration**: A `database.tf` file in the root directory that initializes the database module

Your task is to connect these components and pass the database information to your nginx containers.

### Step 1: Extend Nginx Module Variables

Navigate to your nginx module directory and extend the `~/modules/nginx_container/variables.tf` file:

Add the following new input variables to handle database connection information:

- `db_host` (string) - Database host for nginx container
- `db_port` (number) - Database port for nginx container  
- `db_password` (string, sensitive) - Database password for nginx container


### Step 2: Update Nginx Module Main Configuration

In your nginx modules `main.tf`, update the environment variables section to use the new input variables:

Replace the TODO comments for database-related environment variables:
- `DATABASE_HOST=` → Use `var.db_host`
- `DATABASE_PORT=` → Use `var.db_port`
- `DATABASE_PASSWORD=` → Use `var.db_password`

Also update the templatefile parameters to pass the database values to the HTML template:
- Set `db_host` parameter to `var.db_host`
- Set `db_port` parameter to `var.db_port`

### Step 3: Update Root Module Configuration

Navigate back to your root directory and examine the `~/modules/nginx_container/database.tf` file:

In your root `main.tf`, update both module calls (production and development nginx containers) to include the new database input variables:

For each module call, add the database parameters using the database module outputs:
- `db_host = module.database.container_name`
- `db_port = module.database.db_port`
- `db_password = module.database.db_password`

> **Important**: The database container name serves as the hostname within the Docker network.

### Step 4: Initialize and Apply Configuration

Initialize the configuration to recognize the new database module:
   ```shell
   tofu init
   ```{{exec}}

Format your configuration files:
   ```shell
   tofu fmt
   ```{{exec}}

Validate the configuration:
   ```shell
   tofu validate
   ```{{exec}}

Create an execution plan to see what will be created:
  ```shell  
  tofu plan -out=plan.tfplan
   ```{{exec}}

Review the plan output. You should see:
- A new MySQL database container will be created
- Your existing nginx containers will be updated with database environment variables

Apply the configuration:
   ```shell
   tofu apply plan.tfplan
   ```{{exec}}

### Step 5: Verify Integration

Test that your containerized web servers are accessible. Development should be on port 8080 and production on port 80.
![Access web server in Killercoda](./../assets/access_ports_killercoda.png)

Both pages should now show:
- DATABASE_HOST: The database container name
- DATABASE_PORT: 3306 (MySQL default port)
- DATABASE_PASSWORD: The actual database password (masked for security)

When you click the `Check` button after completing the exercise, the solution for `task-2` will be generated in the corresponding `~/modules/project/solution-2` folder.