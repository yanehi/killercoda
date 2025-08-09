## Foreword

Instead of creating your own modules, you can also obtain modules from central platforms with reusable infrastructure modules, called Module Registries. Both Terraform and OpenTofu offer module registries where the community can publish, share, and discover created modules. These publicly available modules can be easily integrated, configured, and made ready for use via Terraform/OpenTofu code without having to build them from scratch.

![Module Registry Example](./../assets/terraform_modules_example.jpg)
[Source](https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest) 

## Task
In this task, we will create our web server using a module from the Terraform Module Registry. 
The main.tf and provider.tf files, as well as the self-defined database module are available in `task-3`.

1. Open the task-3 folder in the terminal
```
cd ~/modules/task-3
```
2. In the `main.tf` you will find a **TODO** comment in which the external modul should be integrated.
3. Open the [Terraform Module Registry](https://registry.terraform.io/browse/modules) and search for the module `JamaicaBot/docker-nginx`
4. First switch the version on the website to `4.0.0` (we will look into the latest versions later on)
5. Follow the **Provision Instructions** to integrate the module into your code
6. Check which variables need to be set for this module in the `Inputs` tab
7. When finished, execute `tofu init` to download the module definition into the folder `.terraform/modules`
8. Now execute `tofu fmt -recursive`, `tofu validate` and `tofu plan`
9. Now let's increase the module version to `5.0.0`
10. Updating a module requires a new initialization process, so therefore run `tofu init -upgrade`
11. Now execute `tofu fmt -recursive`, `tofu validate` and `tofu plan`
    > **_NOTE:_** You will encounter an error. What could the source of the error be?

### Bonus Task: Module version 6
12. Now let's increase the module version to `6.0.0` and remove the `port` input from the module configuration in the ``main.tf` file
13. Updating a module requires a new initialization process, so therefore run `tofu init -upgrade`
14. Now execute `tofu fmt -recursive`, `tofu validate` and `tofu plan`
    > **_NOTE:_** The error is gone, but did something else change? What is the difference between the two versions?


## Afterword
The OpenTofu and Terraform Module Registries provide a broad selection of pre-built modules that can be seamlessly integrated into your project. 
A major advantage of using these modules is that they can be quickly integrated without having to build them from scratch. However, caution is advised
when using these modules, as you have limited control over their content. Future updates may introduce breaking changes, and relying on outdated versions 
could expose your infrastructure to security vulnerabilities or worse.