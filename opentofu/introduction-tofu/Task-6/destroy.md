The final phase in the OpenTofu lifecycle is the destruction of infrastructure resources. This is an important capability for cleaning up environments, 
removing temporary resources, or completely decommissioning infrastructure. The `tofu destroy` command allows you to safely remove all resources that were 
created and are currently managed by OpenTofu based on your configuration and state file.

When you run `tofu destroy`, OpenTofu will show you a plan of all resources that will be deleted and ask for confirmation before proceeding. This gives you 
a final opportunity to review what will be removed and prevents accidental deletion of important infrastructure.

## Task
1. Navigate to the `~/introduction-tofu/lifecycle-management/` directory where your OpenTofu configuration is located:
   ```shell
   cd ~/introduction-tofu/lifecycle-management
   ```{{exec}}

2. Before destroying resources, you can create a destroy plan to review what will be deleted:
   ```shell
   tofu plan -destroy -out=destroy.tfplan
   ```{{exec}}
   This command creates a destruction plan and saves it to a file. Review the output carefully - you should see that OpenTofu plans to destroy the Docker container that was created in the previous steps.

3. Apply the destroy plan to remove all managed resources:
   ```shell
   tofu apply destroy.tfplan
   ```{{exec}}
   This will execute the destruction plan without asking for additional confirmation since the plan was pre-approved.

4. Alternatively, you can use the direct destroy command (this will ask for confirmation):
   ```shell
   tofu destroy
   ```{{exec}}
   When prompted with "Do you really want to destroy all resources?", type `yes` to confirm the destruction.

5. Verify that the Docker container has been removed:
   ```shell
   docker ps -a | grep web-server
   ```{{exec}}
   This command should return no results, indicating that the container has been successfully removed.

6. Check the state file after destruction:
   ```shell
   tofu show terraform.tfstate
   ```{{exec}}
   The state file should now be empty or show no resources, indicating that OpenTofu is no longer managing any infrastructure.

7. List the remaining files in your directory to see what OpenTofu maintains:
   ```shell
   ls -la
   ```{{exec}}
   Notice that the state file (`terraform.tfstate`) still exists but contains no managed resources, and a backup file (`terraform.tfstate.backup`) contains the previous state before destruction.

> [!CAUTION]
> The `tofu destroy` command will permanently delete all resources managed by OpenTofu in the current configuration. Always review the destroy plan carefully and ensure you have backups of any important data before proceeding. This action cannot be undone.

> [!NOTE]
> After destroying resources, the OpenTofu state file becomes empty, but the configuration files remain unchanged. You can always re-create the same infrastructure by running `tofu apply` again.
