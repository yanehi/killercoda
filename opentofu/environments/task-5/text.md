# Task 5: State Handling and Resource Migration

In this task, you will:
- Move a resource from the root configuration into a module
- Use tofu state mv to migrate state

## Foreword
When refactoring, you may need to move resources into modules. To avoid recreating resources, migrate their state.

## Steps
1. Start with a resource defined in your root `main.tf`.
2. Move the resource definition into a module.
3. Run `tofu state mv` to move the resource's state to the module address:
   ```sh
   tofu state mv <old_address> <new_address>
   ```
   Example:
   ```sh
   tofu state mv docker_container.nginx module.nginx.docker_container.nginx
   ```
4. Run `tofu plan` to confirm no changes are needed.

**Afterword:**
State migration is essential for safe refactoring and modularization. 