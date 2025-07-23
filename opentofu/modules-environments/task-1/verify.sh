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
if ! grep -q 'resource\s*"docker_network"' "$MODULE_MAIN"; then
  echo "docker_network resource not found in module"; exit 1;
fi
if ! grep -q 'resource\s*"docker_image"' "$MODULE_MAIN"; then
  echo "docker_image resource not found in module"; exit 1;
fi
if ! grep -q 'resource\s*"docker_container"' "$MODULE_MAIN"; then
  echo "docker_container resource not found in module"; exit 1;
fi

# Check for required variables in module variables.tf
MODULE_VARS="modules/nginx_container/variables.tf"
if [ ! -f "$MODULE_VARS" ]; then
  echo "Module variables.tf not found"; exit 1;
fi
for var in image container_name network_name; do
  if ! grep -q "variable \"$var\"" "$MODULE_VARS"; then
    echo "Variable '$var' not found in module variables.tf"; exit 1;
  fi
done

# Check for outputs in module outputs.tf
MODULE_OUT="modules/nginx_container/outputs.tf"
if [ ! -f "$MODULE_OUT" ]; then
  echo "Module outputs.tf not found"; exit 1;
fi
for out in container_id network_name; do
  if ! grep -q "output \"$out\"" "$MODULE_OUT"; then
    echo "Output '$out' not found in module outputs.tf"; exit 1;
  fi
done

# Check root main.tf references the module with required variables
if [ ! -f main.tf ]; then
  echo "Root main.tf not found"; exit 1;
fi
if ! grep -q 'module\s*"nginx"' main.tf; then
  echo "Module 'nginx' not referenced in root main.tf"; exit 1;
fi
for var in image container_name network_name; do
  if ! grep -q "$var\s*=\s*" main.tf; then
    echo "Module variable '$var' not set in root main.tf"; exit 1;
  fi
done

echo "Task 1 verification passed!" 