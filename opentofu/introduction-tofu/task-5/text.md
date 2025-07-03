# Task 5: State Manipulation and Useful Commands

In this task, you will:
- Explore the Terraform/OpenTofu state file
- Use commands to inspect and manipulate state

## Foreword

Sometimes, you need to interact directly with the Terraform/OpenTofu state file. This can help you troubleshoot, import existing resources, or clean up your state. The following commands let you inspect, modify, and manage the state file safely.

## Steps
1. **List all resources in state:**
   ```sh
   tofu state list
   ```
   - Shows all resources currently tracked in the state file.

2. **Show details for a resource:**
   ```sh
   tofu state show <resource_name>
   ```
   - Replace `<resource_name>` (e.g., `docker_container.nginx`) to see all attributes stored in state.

3. **Import an existing resource:**
   ```sh
   tofu import <resource_type>.<name> <real_id>
   ```
   - Example: `tofu import docker_container.nginx <container_id>`
   - Brings an existing resource under Terraform/OpenTofu management.

4. **Move a resource in state:**
   ```sh
   tofu state mv <old_address> <new_address>
   ```
   - Example: `tofu state mv docker_container.nginx docker_container.web`
   - Renames or moves a resource in the state file.

5. **Remove a resource from state:**
   ```sh
   tofu state rm <resource_name>
   ```
   - Example: `tofu state rm docker_container.web`
   - Removes a resource from state (does not destroy the real resource).

6. **Destroy all managed resources:**
   ```sh
   tofu destroy
   ```
   - Removes all resources defined in your configuration.

**Tip:** Use these commands to keep your state file clean and accurate. Always be careful when manipulating state directly.

## Afterword

State manipulation commands are powerful tools for advanced users. They help you recover from errors, import existing infrastructure, and keep your state file in sync with reality. Use them with care, and always review changes before applying them to your infrastructure. 