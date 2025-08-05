## Foreword
Environment handling with OpenTofu/Terraform is a powerful way to manage different configurations for various stages of your infrastructure lifecycle, such as development, testing or production. 
In many cases you want to mirrow the same infrastructure compontets accross all environments, but slightly adjust configuration parameters or include values that are specifically for that environment. 
Additionally you want to group your environment parameters on a central place to make it easier to manage them. 

![Environment Handling Overview](./assets/environment_handling_version1.png)
One option to achieve this goal is to seperate the infrastructure definition from the input parameters. While the infrastructure definition is defined at root level the actual input values are moved to specific `*.tfvars`
and referenced via variables. This ensures consistent infrastructure across all environments, reduces code duplication, and speeds up the provisioning of new environments.
One disadvantage of this method is the complicated adjustment mechanisms required when infrastructure components differ across environments.

## Task
In this task a configuration is provided in the `main.tf` that defines a simple web application with a database and docker network. 
Accross the confuguration you will find multiple hardcoded values that define the configuration for the dev environment. Your task is to refactor the configuration to use variables and create a `dev.tfvars` file that contains the values for the dev environment.
1. First run the command `tofu init`, `tofu apply` to provision the infrastructure as it is defined in `main.tf`
2. Create a `variable.tf` file and define the following variables from `main.tf` into this file as variables. The hardcoded values to be moved are signed with `TODO: Move to variable.tf`.
   - `environment`: The environment name (e.g., "dev", "prod")
   - `app_url`: The URL of the web application
   - `db_name`: The name of the database
   - `db_user`: The database user
   - `db_password`: The database password
   - `db_port`: The port for the database connection
   - `container_name`: The name of the database container
   - `image_name`: The Docker image for the web server
   - `web_container_name`: The name of the web server container
   - `web_external_port`: The external port of the web server
   - `network_name`: The name of the Docker network
   - `network_subnet`: The subnet for the Docker network
3. Create the directory with the file `env/dev.tfvars` and define the values for the variables you created in form of key-value pairs. Use the values from `main.tf` as a reference. They are referenced with ´TODO: Replace with variable´
4. Replace the hardcoded values in `main.tf` with the variables you defined in `variable.tf`. Use the syntax `var.<variable_name>` to reference the variables.
5. Run the commands `tofu fmt -recursive`, `tofu validate`, `tofu plan -var-file=env/dev.tfvars -state="dev-state"` and `tofu apply -var-file=env/dev.tfvars -state="dev-state"`
6. Verify that the infrastructure is provisioned correctly and that the web application is accessible at the URL defined in `dev.tfvars`.
7. Create a additional `prod.tfvars` file for the prod environment configuration with the following values 
    - `environment`: "prod"
    - `app_url`: "http://localhost:80"
    - `db_name`: "webapp_db_prod"
    - `db_user`: "webapp_user_prod"
    - `db_password`: "zP8~99^1W7zA"
    - `db_port`: 3307
    - `container_name`: "webapp-database-prod"
    - `image_name`: "nginx:latest"
    - `web_container_name`: "webapp-nginx-prod"
    - `web_external_port`: 80
    - `network_name`: "webapp-network-prod"
    - `network_subnet`: "172.21.0.0/16"
8. Run the commands `tofu fmt -recursive`, `tofu validate`, `tofu plan -var-file=env/prod.tfvars -state="prod-state"` and `tofu apply -var-file=env/prod.tfvars -state="prod-state"`
