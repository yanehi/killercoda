# Task 6: Best Practices and Clean-up

In this task, you will:
- Review best practices for modules and environments
- Clean up all resources

## Foreword
Following best practices ensures your infrastructure is maintainable and scalable.

## Steps
1. Review your folder and file structure. Ensure modules and environments are clearly separated.
2. Check that all modules use version pinning and have clear variable/outputs definitions.
3. Ensure all environments have their own tfvars and configuration files.
4. Destroy resources in all environments using `tofu destroy -var-file=terraform.tfvars`.

## Best Practices Checklist
- [ ] Modules are reusable and versioned
- [ ] Environments are isolated
- [ ] Variables and outputs are well-documented
- [ ] No unused resources or variables
- [ ] Code is formatted and validated

**Afterword:**
Regularly review and clean up your infrastructure to keep it healthy and manageable. 