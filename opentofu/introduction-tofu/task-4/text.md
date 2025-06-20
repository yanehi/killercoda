# Task 4: State Manipulation and Useful Commands

In this task, you will:
- Explore the Terraform/OpenTofu state file
- Use commands to inspect and manipulate state

## Steps
1. List all resources in state:
   ```sh
   tofu state list
   ```
2. Show details for a resource:
   ```sh
   tofu state show docker_container.nginx
   ```
3. Import an existing Docker container (replace `<container_id>`):
   ```sh
   tofu import docker_container.nginx <container_id>
   ```
4. Move a resource in state (example):
   ```sh
   tofu state mv docker_container.nginx docker_container.web
   ```
5. Remove a resource from state:
   ```sh
   tofu state rm docker_container.web
   ```
6. Destroy all managed resources:
   ```sh
   tofu destroy
   ```

**Tip:** Use these commands to keep your state file clean and accurate. 