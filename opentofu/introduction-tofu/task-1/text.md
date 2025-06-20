# Task 1: Terraform Syntax and Basics

In this task, you will:
- Write a basic Terraform/OpenTofu configuration
- Use variables and outputs
- Format and validate your configuration

## Steps
1. Create a file named `main.tf` with the following content:
   ```hcl
   terraform {
     required_version = ">= 1.0.0"
   }
   
   variable "greeting" {
     description = "A welcome message"
     type        = string
     default     = "Hello, OpenTofu!"
   }
   
   output "message" {
     value = var.greeting
   }
   ```
2. Run `tofu fmt` to format your code.
3. Run `tofu validate` to check for errors.
4. View the output using `tofu output` after applying (in later tasks).

**Tip:** Try changing the variable default and see the output change. 