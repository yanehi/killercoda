#!/bin/bash
set -e

# Check module folder exists
if [ ! -d modules/nginx_container ]; then
  echo "Module folder modules/nginx_container not found"; exit 1;
fi

# Check for required resource blocks in module main.tf
MODULE_MAIN="modules/nginx_container/main.tf"
if [ ! -f "$MODULE_MAIN" ]; then
  echo "Module main.tf not found"; exit 1;
fi
if ! grep -q 'resource[[:space:]]*"docker_network"' "$MODULE_MAIN"; then
  echo "docker_network resource not found in module"; exit 1;
fi
if ! grep -q 'resource[[:space:]]*"docker_image"' "$MODULE_MAIN"; then
  echo "docker_image resource not found in module"; exit 1;
fi
if ! grep -q 'resource[[:space:]]*"docker_container"' "$MODULE_MAIN"; then
  echo "docker_container resource not found in module"; exit 1;
fi

# Check for required variables in module variables.tf
MODULE_VARS="modules/nginx_container/variables.tf"
if [ ! -f "$MODULE_VARS" ]; then
  echo "Module variables.tf not found"; exit 1;
fi
for var in image container_name network_name; do
  if ! grep -q "variable[[:space:]]*\"$var\"" "$MODULE_VARS"; then
    echo "Variable '$var' not found in module variables.tf"; exit 1;
  fi
done

# Check for outputs in module outputs.tf
MODULE_OUT="modules/nginx_container/outputs.tf"
if [ ! -f "$MODULE_OUT" ]; then
  echo "Module outputs.tf not found"; exit 1;
fi
for out in container_id network_name; do
  if ! grep -q "output[[:space:]]*\"$out\"" "$MODULE_OUT"; then
    echo "Output '$out' not found in module outputs.tf"; exit 1;
  fi
done

# Check root main.tf references the module with required variables
if [ ! -f main.tf ]; then
  echo "Root main.tf not found"; exit 1;
fi
if ! grep -q 'module[[:space:]]*"nginx"' main.tf; then
  echo "Module 'nginx' not referenced in root main.tf"; exit 1;
fi

# Check if module source is correctly set
if ! grep -q 'source[[:space:]]*=[[:space:]]*"\./modules/nginx_container"' main.tf; then
  echo "Module source path not correctly set to './modules/nginx_container'"; exit 1;
fi

# Check if required module variables are set in root main.tf
for var in image container_name network_name; do
  if ! grep -q "$var[[:space:]]*=" main.tf; then
    echo "Module variable '$var' not set in root main.tf"; exit 1;
  fi
done

# Check if OpenTofu files are present and valid
if [ ! -f ".terraform.lock.hcl" ] && [ ! -d ".terraform" ]; then
  echo "OpenTofu not initialized. Run 'tofu init' first"; exit 1;
fi

# Validate OpenTofu configuration
if ! tofu validate > /dev/null 2>&1; then
  echo "OpenTofu configuration validation failed. Run 'tofu validate' to see errors"; exit 1;
fi

# Check if configuration is formatted
if ! tofu fmt -check -recursive > /dev/null 2>&1; then
  echo "OpenTofu configuration not properly formatted. Run 'tofu fmt -recursive'"; exit 1;
fi

echo "Task 1 verification passed!"
