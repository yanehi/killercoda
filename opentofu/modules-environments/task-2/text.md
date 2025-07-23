# Task 2: Using Module Versions

In this task, you will:
- Learn to use and reference specific module versions
- Understand version pinning

## Foreword
Pinning module versions ensures stability and repeatability in your infrastructure. You can use modules from the Terraform Registry or local sources.

## Steps
1. If using a remote module, specify the version in your module block:
   ```hcl
   module "nginx" {
     source  = "app.terraform.io/example/nginx_container/docker"
     version = "1.0.0"
     image   = "nginx:latest"
     name    = "my-nginx"
   }
   ```
   (Replace with a real module if available, or use a local path for this exercise.)
2. If using a local module, simulate versioning by copying the module folder and referencing a specific versioned folder.
3. Update the module version and observe any changes in behavior or configuration.

**Afterword:**
Always pin module versions in production to avoid unexpected changes when modules are updated. 