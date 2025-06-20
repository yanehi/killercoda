# Task 2: Providers and Provider Syntax

In this task, you will:
- Add and configure the kreuzwerker/docker provider
- Initialize your Terraform/OpenTofu project

## Steps
1. Add the following to your `main.tf`:
   ```hcl
   terraform {
     required_providers {
       docker = {
         source  = "kreuzwerker/docker"
         version = ">= 3.0.0"
       }
     }
   }
   
   provider "docker" {}
   ```
2. Run `tofu init` to download the provider and initialize your project.
3. Check that the `.terraform` directory is created and the provider is installed.

**Tip:** You can view installed providers in `.terraform/providers`. 