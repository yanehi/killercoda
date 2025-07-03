# Task 6: Refactoring Best Practices

In this task, you will:
- Refactor your configuration using best practices
- Organize your code into logical files
- Use clear naming, descriptions, and comments
- Remove unused code and format your files

## Foreword

Refactoring is more than just splitting files—it's about making your code easier to read, maintain, and scale. Following best practices helps you and your team avoid mistakes and work more efficiently. In this task, you'll apply key refactoring habits to your Terraform/OpenTofu project.

## Steps

1. **Organize your files:**
   - Move all `variable` blocks to `variables.tf`.
   - Move all `output` blocks to `outputs.tf`.
   - Move all `locals` blocks to `locals.tf`.
   - Keep your main resources in `main.tf`.

2. **Use consistent naming conventions:**
   - Give resources, variables, and outputs clear, descriptive names (e.g., `docker_container.web` instead of `docker_container.nginx1`).
   - Use lowercase and underscores for multi-word names.

3. **Add descriptions and comments:**
   - Add a `description` to every variable and output.
   - Use comments to explain any complex logic or important decisions.

4. **Remove unused code:**
   - Delete any variables, resources, outputs, or locals that are no longer needed.

5. **Format and validate your code:**
   - Run `tofu fmt` to format all configuration files.
   - Run `tofu validate` to check for errors.

## Refactoring Checklist

- [ ] All variable blocks are in `variables.tf`
- [ ] All output blocks are in `outputs.tf`
- [ ] All locals blocks are in `locals.tf`
- [ ] All resources are in `main.tf`
- [ ] All names are clear and consistent
- [ ] All variables and outputs have descriptions
- [ ] Unused code is removed
- [ ] Code is formatted and validated

## Afterword

Applying these best practices will make your Terraform/OpenTofu codebase easier to manage and scale. Clean, well-organized code is essential for professional infrastructure projects and effective teamwork. Regularly review and refactor your configuration as your project grows. 