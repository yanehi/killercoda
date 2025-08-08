# Task 2

## Foreword
Building upon the module concept from Task 1, we now explore how modules can work together and share information through outputs and inputs. 
This creates a powerful way to build complex infrastructure by connecting different components. Let's explore the configuration from the `main.tf`
```hcl
# This uses both nginx and database modules with container ID dependency

module "database" {
  source         = "./modules/database_container"
  image_name     = "mysql:8.0"
  container_name = "my-mysql"
  db_name        = "myapp"
  db_user        = "root"
  db_password    = "password123"
  db_port        = 3306
}

module "nginx_latest" {
  source         = "./modules/nginx_container"
  image_name     = "nginx:latest"
  container_name = "my-nginx"
  port           = 80

  # Pass database container ID, host, and port as variables
  db_container_id = module.database.container_id
  db_host         = module.database.container_name
  db_port         = module.database.db_port
  db_password     = module.database.db_password
}
```

**Module Dependencies and Outputs:**
When modules need to communicate with each other, they can use outputs from one module as inputs to another. This creates dependencies that ensure resources are created in the correct order and allows modules to share information like container IDs, IP addresses, or connection details.

**Environment Variables in Containers:**
Containers often need configuration information from other containers or external sources. By passing outputs from one module as environment variables to another, we can create dynamic, interconnected applications.

## Task
Create a multi-module infrastructure with a database container and an nginx container, where the database container ID is passed as an environment variable to the nginx container.
1. Open the task-1 folder in the terminal
```
cd ~/modules/task-2
```{{exec}}

2. Start by creating the following folder structure:
```plaintext
task-2/
├── modules/
│   ├── nginx_container/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── database_container/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── provider.tf
└── main.tf  
```

3. In the `modules/database_container/variables.tf`, define all the input parameters that are used by the database module from the `main.tf`
   - **image_name** for the database image name
   - **container_name** for the database container name
   - **db_name** for the database name
   - **db_user** for the database user
   - **db_password** for the database password (mark as sensitive)
   - **db_port** for the database port (default: 3306)

4. In `modules/database_container/main.tf`, define the following resources from the [Kreuzwerk Provider](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs):
   - **docker_image** resource for the MySQL image using the `image_name` variable
   - **docker_container** resource for the MySQL container with:
     - Environment variables for database configuration (MYSQL_ROOT_PASSWORD, MYSQL_DATABASE, MYSQL_USER and MYSQL_PASSWORD)
     - Port mapping using the `db_port` variable
     - Health check to ensure the database is ready (Interval: 10s, Timeout: 5s, Retries: 5, StartPeriod: 30s)

5. In `modules/database_container/outputs.tf`, define the necessary outputs that are used by the nginx module from the `main.tf`:
   
6. In the `modules/nginx_container/variables.tf`, define all the input parameters that are used by the nginx module from the `main.tf`. Additionally, mark the `db_password` variable as sensitive

7. In `modules/nginx_container/main.tf`, expand the `docker_container` resource to use the database connection values as environment variables.

8. To verify the correctness of your implementation run
- `tofu init`
- `tofu fmt -recursive`
- `tofu validate`
- `tofu apply` to provision both containers with the dependency relationship.
9. You can check the status of the container with the command:
```bash
docker ps
```
10. You can access the nginx container within Killercoda on the port you defined for the nginx container (default: 80):
    ![Everything fine](./../assets/access_ports_killercoda.png)
11. Clean up after reviewing with `tofu destroy`

### Bonus Task: Hand over environment variables as a list to the nginx container
 1. Use the [Kreuzwerk resource definition](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container#env-4) for the `env` parameter to hand over the environment variables as a list to the module. 
 2. Use [Dynamic Blocks](https://opentofu.org/docs/language/expressions/dynamic-blocks/) to insert all environment variables from the list to the database container in the database module.

## Afterword
By creating multiple modules that can communicate through outputs and inputs, you can build complex, interconnected infrastructure. 
The database container ID is automatically passed to the nginx container as an environment variable, demonstrating how modules can share information and create dependencies.

📝 **Key Concepts:** 
- **Module Dependencies**: The nginx module depends on the database module, ensuring the database is created first
- **Output/Input Flow**: Database container ID flows from database module → root module → nginx module
- **Environment Variables**: Dynamic configuration passed to containers at runtime
- **Sensitive Data**: Database passwords are marked as sensitive for security
