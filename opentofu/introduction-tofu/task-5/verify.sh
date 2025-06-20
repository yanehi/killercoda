#!/bin/bash
set -e

# Check variables.tf and outputs.tf
if [ ! -f variables.tf ]; then
  echo "variables.tf not found"; exit 1;
fi
if [ ! -f outputs.tf ]; then
  echo "outputs.tf not found"; exit 1;
fi

# Check tofu fmt
if ! tofu fmt -check -diff; then
  echo "Formatting issues found"; exit 1;
fi

# Check state rename
if ! tofu state list | grep -q 'docker_container.nginx_web'; then
  echo "Resource 'docker_container.nginx_web' not found in state. Did you run 'tofu state rename'?"; exit 1;
fi

echo "Task 5 verification passed!" 