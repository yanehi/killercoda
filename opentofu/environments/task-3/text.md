# Task 3: Multi-Environment Provisioning

In this task, you will:
- Provision infrastructure for test, stage, and prod environments using two different approaches
  - Configure your infrastructure for different environments by inserting different `*.tfvars` files to manage environment-specific variables

## Foreword
In real-world scenarios, you often need to manage multiple environments like test, stage, and production. 
Using separate folders for each environment allows you to keep configurations organized and maintainable. Each environment can have its own set of variables defined in `terraform.tfvars` files, which makes it easy to customize settings without changing the main configuration files.

## Steps
1. Create folders for each environment:
   ```plaintext
   envs/
     test/
       main.tf
       terraform.tfvars
     stage/
       main.tf
       terraform.tfvars
     prod/
       main.tf
       terraform.tfvars
   ```
2. In each `main.tf`, reference your module and use variables for environment-specific values.
3. In each `terraform.tfvars`, set values like container name, image, or ports.
4. Run `tofu plan -var-file=terraform.tfvars` and `tofu apply -var-file=terraform.tfvars` in each environment folder.

**Afterword:**
Using separate folders and tfvars files helps you manage differences between environments safely and clearly. 