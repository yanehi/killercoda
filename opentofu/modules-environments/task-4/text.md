# Task 4: Passing and Managing Environment Variables

In this task, you will:
- Pass variables using different methods
- Concatenate variables for dynamic configuration

## Foreword
Terraform/OpenTofu supports multiple ways to pass variables: directly in code, via tfvars files, or as environment variables. Understanding precedence and concatenation is key for flexible configs.

## Steps
1. Use variables and locals in your configuration to build dynamic values (e.g., concatenate environment and app name for a container name).
2. Set variables in `terraform.tfvars` and override them with CLI flags or environment variables (`TF_VAR_<name>`).
3. Demonstrate variable precedence by setting the same variable in multiple places and observing which value is used.
4. Use locals to combine or transform variables as needed.

**Afterword:**
Flexible variable handling lets you adapt your infrastructure to different needs and environments. 