After the initialization of OpenTofu in the `~/introduction-tofu/lifecycle-management/` directory, 
the next step is to plan the provisioning Docker Container web server. The planning phase is a recommended step in the OpenTofu workflow, 
where you can preview the changes that will be made to your infrastructure before applying them. The outcome of the plan is a detailed report 
of the actions (like creating, changing or deleting infrastructure components) that OpenTofu will take when you apply your code. This step is recommended 
to ensure that the changes are as expected and to avoid any unintended changes with consequences.


## Task
1. In the `~/introduction-tofu/lifecycle-management/` directory, run the following command to create a plan for the OpenTofu configuration:
   ```shell
   tofu plan
   ```{{exec}}
2. Review the output of the command in the console. Since no infrastructure has been created by OpenTofu yet, 
the output only contains one resource that will be added. The Docker container resource from the 
`main.tf` is specified with the name `web_server` at the top of the output. Additionally, you can also find the configuration parameters `nginx:latest`, 
the defined ports `80` and the html content. The remaining attributes are the default values for the Docker container resource.
3. Please safe the plan to a file for later review. Use the `-out` option to save it:
   ```shell
   tofu plan -out=plan.tfplan
   ```{{exec}}
   This command will create a file named `plan.tfplan` that contains the planned actions. Should you change your configuration further, but still want to apply the same plan, you can use this file later.
4. To review the `plan.tfplan` at a later time, the following command can be used:
   ```shell
   tofu show plan.tfplan
   ```{{exec}}
   This command will display the changes described in the `plan.tfplan` file, showing the Docker container configuration as specified in your configuration.
