# Task 5: Refactoring and Best Practices

In this task, you will:
- Refactor your configuration into multiple files
- Rename resources in state
- Format your code

## Steps
1. Move variable and output blocks into separate files (`variables.tf`, `outputs.tf`).
2. Use `tofu state rename` to rename a resource (example):
   ```sh
   tofu state rename docker_container.nginx docker_container.nginx_web
   ```
3. Run `tofu fmt` to format all configuration files.

**Tip:** Organizing your code improves readability and maintainability. 