## Foreword
The infrastructure can grow dynamically over the course of a project. New requirements mean new components are needed that aren't necessarily required in all environments.
The following example shows what this dynamic infrastructure might look like.

![Environment Handling Overview](../assets/tofu-killercoda-training-enivornment-dynamic_infrastructure_design.drawio.png)

- The server still remains a constant infrastructure component across all environments
- On the dev and test environment a scheduler and a batch jobs for data migration of external systems are required
- On the staging environment a virtual machine that hosts a load generator needs to be temporary provisioned, to test the scalability of the system
- On the production environment an additional storage to store backups needs to be available 

Although the previous design could also handle this case, the count conditions make the code more difficult to understand. For this reason, a different design will be presented for this task.

## Task
In this task, the same configuration is provided in the `dev/main.tf` that defines the same web application with a database and docker network. 
Across the configuration you will find multiple hardcoded values that define the configuration for the dev environment. 
Your task is to refactor the configuration to use `locals` reference and centralize all configuration values in a `locals.tf` file for the dev environment.


### Step 0: Preparation and testing the existing code
1. Navigate to the `dev` directory
2. Run the command `tofu init` to initialize the OpenTofu environment.
3. Run the command `tofu fmt -recursive` to format the code.
4. Run the command `tofu validate` to check the syntax of the configuration.
5. Run the command `tofu plan` to create an execution plan for the infrastructure.
6. Run the command `tofu apply -state="dev-state"` to provision the infrastructure as defined in `main.tf`.

### Step 1: Create a locals.tf file and move hardcoded values
1. Create a `locals.tf` file in the same directory as your `main.tf`.
2. Define a `locals` block and move all hardcoded values marked with `# TODO: Replace with locals` into this block as key-value pairs.

The following values should be moved to locals:

| Local Name | Description | Current Hardcoded Value |
|------------|-------------|-------------------------|
| `network_name` | The name of the Docker network | "webapp-network-dev" |
| `network_subnet` | The subnet for the Docker network | "172.20.0.0/16" |
| `container_name` | The name of the database container | "webapp-database-dev" |
| `db_name` | The name of the database | "webapp_db_dev" |
| `db_user` | The database user | "webapp_user_dev" |
| `db_password` | The database password | "secure_password_123" |
| `db_port` | The port for the database connection | 3306 |
| `image_name` | The Docker image for the web server | "nginx:alpine" |
| `web_container_name` | The name of the web server container | "webapp-nginx-dev" |
| `web_external_port` | The external port of the web server | 8080 |
| `environment` | The environment name | "dev" |
| `app_url` | The URL of the web application | "http://localhost:8080" |

### Step 2: Replace hardcoded values with local references
1. Replace all hardcoded values in `main.tf` that are marked with `# TODO: Replace with locals` with the corresponding local references.
2. Use the syntax `local.<local_name>` to reference the local values.

### Step 3: Validate and deploy the refactored code
1. Run the commands:
   - `tofu fmt -recursive`
   - `tofu validate`
   - `tofu plan`
   - `tofu apply -state="dev-state"`
2. Verify that the web application is still accessible at the URL defined in your locals.

### Step 4: Create a production environment
1. Create a new `prod` folder beside the `dev` folder
2. Copy the content of the `dev` folder into the `prod`. Your folder structure should look like this:
```
task-2/
├── dev/
│   ├── index.html.tpl
│   ├── main.tf
│   ├── locals.tf
│   └── provider.tf
└── prod/
    ├── index.html.tpl
    ├── main.tf
    ├── locals.tf
    └── provider.tf
```
3. Adjust the `prod/locals.tf` 

| Variable | Value |
|----------|-------|
| `environment` | "prod" |
| `app_url` | "http://localhost:80" |
| `db_name` | "webapp_db_prod" |
| `db_user` | "webapp_user_prod" |
| `db_password` | "zP8~99^1W7zA" |
| `db_port` | 3307 |
| `container_name` | "webapp-database-prod" |
| `image_name` | "nginx:latest" |
| `web_container_name` | "webapp-nginx-prod" |
| `web_external_port` | 80 |
| `network_name` | "webapp-network-prod" |
| `network_subnet` | "172.21.0.0/16" |
4. Run the commands
   - `cd ../prod`
   - `tofu init`
   - `tofu fmt -recursive`
   - `tofu validate`
   - `tofu plan -state="prod-state"`
   - `tofu apply -state="prod-state"`

### Step 5: Conditional Resource Creation
1. For this task new requirements are defined for the the infrastructure configuration.
- On the dev environment, you want to add a debug container for Redis `redis:alpine` to help with caching and session management. 
- In the production environment, you want to add a redundant db backup service that runs periodically to ensure data safety.

2. Please add the required ressources to the appropriate `main.tf` files in the `dev` and `prod` directories.
3. Deploy and verify both environments:
```
# Test dev environment
cd dev
tofu plan -state="dev-state"
tofu apply -state="dev-state"

# Test prod environment
cd ../prod
tofu plan -state="prod-state"
tofu apply -state="prod-state"

# Verify containers
docker ps
```

### Afterword
This task demonstrates how to provision multiple environments dynamically using redundant code. By duplicating the same infrastructure definition with different configuration values,
you can achieve rapid environment provisioning while maintaining a clean separation of concerns. Note that infrastucture code does not behave like application code, and duplication is 
often necessary to achieve the desired flexibility on the long run. Hence, overall changes to the same infrastucture definition becomes a repetitive task for multiple environments and 
might as well be prone to errors or misconfigurations.