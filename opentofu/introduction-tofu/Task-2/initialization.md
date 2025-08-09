OpenTofu as an Infrastructure-as-Code tool is divided into two essential components:
- **OpenTofu configurations**: These are files with the extension `*.tf` or `*.tofu`, which define a target infrastructure through self-written code. 
Any number of these configuration files can be stored within a folder, which are all recognized and processed by OpenTofu during the provisioning process.
- **OpenTofu CLI**: The command-line tool that processes the configurations and manages the infrastructure based on the `terraform.tfstate` file. The state file contains 
the current infrastructure created by OpenTofu. More information about the state can be found in the [OpenTofu Documentation](https://opentofu.org/docs/language/state/).

> [!NOTE]  
> OpenTofu is compatible with `*.tf` and `*.tofu` files, as they are written in HCL (HashiCorp Configuration Language). Terraform explicitly only works with `*.tf` files. 
> For this reason, we prefer to use `*.tf` files in this training.

## Task
In the following steps, you will learn how to use the OpenTofu CLI and how it is used to create, modify, and delete infrastructure. 
For this purpose, a Docker infrastructure resource will be created that provides an nginx web server. Proceed as follows:
1. Navigate to the directory
    ```shell
    cd ~/introduction-tofu/lifecycle-management
    ```{{exec}}
2. In this directory, there is a `main.tf` file that contains an OpenTofu configuration and defines the corresponding resource. It contains:
- A provider that specifies that Docker is used as the infrastructure resource.
- A resource that provides an nginx web server and integrates a customized HTML file.
3. To create the container, OpenTofu must be initialized in the current directory. Execute the following command:
    ```shell
    tofu init 
    ```{{exec}}

After initialization is complete, there are two new contents in the current directory. The `.terraform` directory downloads relevant metadata, provider binaries, and plugins once,
which are needed for provisioning the infrastructure. The `.terraform.lock.hcl` file records which exact versions of your providers (and their checksums) were installed during the last `tofu init`.
It ensures that everyone working on the project uses the same provider versions, making reproducible deployments possible.
