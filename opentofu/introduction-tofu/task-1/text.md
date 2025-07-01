# Task 1: Providers and Provider Syntax
In this task, you will:
- Learn how to add and configure the kreuzwerker/docker provider
- Initialize your Terraform/OpenTofu project

## Foreword
A Terraform provider is a plugin that allows Terraform to interact with an external platform or service. The provider acts as an API bridge between Terraform/OpenTofu and the target system—such as AWS, Azure, Google Cloud, Kubernetes, GitHub, etc. A full list of providers that can be used by Terraform/OpenTofu can be found in the [Terraform Registry](https://registry.terraform.io/browse/providers).

Each provider defines a number of configurable resources that are unique to the target platform. For example, the configuration of an S3 storage bucket is unique to AWS. In order for Terraform/OpenTofu to recognize the resources and configuration options, a provider block must be present in a `*.tf` file so that these definitions can be downloaded.

For this task, the `kreuzwerker/docker` provider needs to be downloaded. The `kreuzwerker/docker` provider documentation can be found [here](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs).

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

**Note:** You can view installed providers in `.terraform/providers`.

## Afterword
Terraform/OpenTofu providers include a `version` parameter that specifies the version of the provider to be downloaded. Different provider versions might introduce new configuration parameters and resources, but may also deprecate older resources.  
