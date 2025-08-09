So far, we have covered the typical workflow for the initial provisioning of infrastructure resources with OpenTofu. This process, known as "Day-1 Provisioning," involves the creation and 
configuration of resources at the beginning of a project. All continuous adjustments and updates made after the initial deployment fall under the term "Day-n Provisioning." This includes 
resource management, drift remediation, and updating configurations for a growing and constantly changing infrastructure.


## Task
In the previous steps, you created and deployed a Docker container with a custom HTML page. Now you will learn how OpenTofu handles configuration changes by modifying the existing HTML content. This demonstrates how OpenTofu can update existing infrastructure resources without recreating them from scratch.
When you modify the HTML content in your OpenTofu configuration, OpenTofu will detect the change and update the running container with the new content. This is an example of infrastructure drift management and configuration updates.
1. Navigate to the `~/introduction-tofu/lifecycle-management/` directory and open the `main.tf` file. Locate the HTML content in the `upload` block and modify it to show different content. For example, change the title and add a new paragraph:
   
   ```hcl
   upload {
     content = <<-EOT
       <!DOCTYPE html>
       <html>
       <head>
           <title>Updated OpenTofu Deployment</title>
       </head>
       <body>
           <h1>Infrastructure Updated Successfully!</h1>
           <p>This page has been updated using OpenTofu configuration changes.</p>
           <p>OpenTofu detected the change and updated the running container.</p>
       </body>
       </html>
     EOT
     file    = "/usr/share/nginx/html/index.html"
   }
   ```

2. After modifying the HTML content, validate that your configuration is still syntactically correct:
   ```shell
   tofu validate
   ```{{exec}}
   This checks if the configuration in the current directory is syntactically correct and all required parameters are set.
   
3. Now you can apply the configuration to update the running container. First, create a new plan to see what changes OpenTofu will make:
   ```shell
   tofu plan -out=plan.tfplan
   ```{{exec}}
   Review the output carefully.

4. Apply the changes to update the HTML content:
   ```shell
   tofu apply plan.tfplan
   ```{{exec}}

5. Verify that the changes have been applied by accessing the web server. You can access the web server in Killercoda by following the steps in the image below. Make sure to access port `80` as defined in the `main.tf` file.
   ![Access web server in Killercoda](./../assets/access_ports_killercoda.png)
   
   You should now see the updated HTML content with the new title and additional paragraph. If not make sure to clear your browser cache or try accessing the page in incognito mode.

6. Check the updated state file to see how OpenTofu tracks these changes:
   ```shell
   tofu show terraform.tfstate
   ```{{exec}}
   Notice how the state file now reflects the updated configuration while maintaining the same container ID.
