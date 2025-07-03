#!/bin/bash
set -e

# Check main.tf exists
if [ ! -f main.tf ]; then
  echo "main.tf not found"; exit 1;
fi

# Check tofu fmt and validate
if ! tofu fmt -check -diff; then
  echo "Formatting issues found"; exit 1;
fi
if ! tofu validate; then
  echo "Validation failed"; exit 1;
fi

# Check for variable block
if ! grep -q 'variable\s*"container_name"' main.tf; then
  echo "Variable block 'container_name' not found"; exit 1;
fi

# Check for locals block with container_image
if ! grep -q 'locals\s*{' main.tf || ! grep -q 'container_image\s*=\s*"nginx:latest"' main.tf; then
  echo "Locals block with 'container_image' not found"; exit 1;
fi

# Check docker_image resource uses local.container_image
if ! grep -q 'resource\s*"docker_image"' main.tf || ! grep -q 'name\s*=\s*local.container_image' main.tf; then
  echo "docker_image resource using local.container_image not found"; exit 1;
fi

# Check docker_container resource uses var.container_name
if ! grep -q 'resource\s*"docker_container"' main.tf || ! grep -q 'name\s*=\s*var.container_name' main.tf; then
  echo "docker_container resource using var.container_name not found"; exit 1;
fi

# Check for output blocks
if ! grep -q 'output\s*"container_name"' main.tf; then
  echo "Output block 'container_name' not found"; exit 1;
fi
if ! grep -q 'output\s*"container_image"' main.tf; then
  echo "Output block 'container_image' not found"; exit 1;
fi

echo "Task 3 verification passed!" 