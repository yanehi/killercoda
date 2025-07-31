# Task 2

## Foreword
Building upon the module concept from Task 1, we now explore how modules can work together and share information through outputs and inputs. This creates a powerful way to build complex infrastructure by connecting different components.

**Module Dependencies and Outputs:**
When modules need to communicate with each other, they can use outputs from one module as inputs to another. This creates dependencies that ensure resources are created in the correct order and allows modules to share information like container IDs, IP addresses, or connection details.

**Environment Variables in Containers:**
Containers often need configuration information from other containers or external sources. By passing outputs from one module as environment variables to another, we can create dynamic, interconnected applications.

## Task
Create a multi-module infrastructure with a database container and an nginx container, where the database container ID is passed as an environment variable to the nginx container.

1. Start by creating the following folder structure:
```plaintext
modules/
├── nginx_container/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── database_container/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

2. In the `modules/database_container/variables.tf`, define the input parameters:
   - **image_name** for the database image name
   - **container_name** for the database container name
   - **db_name** for the database name
   - **db_user** for the database user
   - **db_password** for the database password (mark as sensitive)
   - **db_port** for the database port (default: 3306)

3. In `modules/database_container/main.tf`, define the following resources from the [Kreuzwerk Provider](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs):
   - **docker_image** resource for the MySQL image using the `image_name` variable
   - **docker_container** resource for the MySQL container with:
     - Environment variables for database configuration (MYSQL_ROOT_PASSWORD, MYSQL_DATABASE, etc.)
     - Port mapping using the `db_port` variable
     - Health check to ensure the database is ready

4. In `modules/database_container/outputs.tf`, define outputs for:
   - **container_id** - the ID of the database container
   - **container_name** - the name of the database container
   - **db_port** - the port exposed by the database
   - **db_password** - the port exposed by the database

5. In the `modules/nginx_container/variables.tf`, expand the input parameters:
   - **db_container_id** - the container id of the database
   - **db_host** - the container name in which the DB is hosted
   - **db_port** - the port on which the database can be accessed
   - **db_password** the password of the database to connect to (mark as sensitive)

6. In `modules/nginx_container/main.tf`, expand the `docker_container` ressource to use the values from `environment_variables` previously defined. As a hint use the [Kreuzwerk ressource definition](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container#env-4) as well as the [Dynamic Blocks](https://opentofu.org/docs/language/expressions/dynamic-blocks/)

7. Run `tofu init`, `tofu fmt -recursive`, `tofu validate` and `tofu apply` to provision both containers with the dependency relationship.
8. (Optional) Inspect the successfull container configuration with:
   - `docker inspect my-mysql` for the database
   - `docker inspect my-nginx` for the webservice
9. Clean up after reviewing with `tofu destroy`


## Afterword:
By creating multiple modules that can communicate through outputs and inputs, you can build complex, interconnected infrastructure. The database container ID is automatically passed to the nginx container as an environment variable, demonstrating how modules can share information and create dependencies.

📝 **Key Concepts:** 
- **Module Dependencies**: The nginx module depends on the database module, ensuring the database is created first
- **Output/Input Flow**: Database container ID flows from database module → root module → nginx module
- **Environment Variables**: Dynamic configuration passed to containers at runtime
- **Sensitive Data**: Database passwords are marked as sensitive for security
