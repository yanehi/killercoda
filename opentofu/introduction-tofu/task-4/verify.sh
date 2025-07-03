#!/bin/bash
set -e

# Check tofu init
if [ ! -d .terraform ]; then
  echo ".terraform directory not found. Run 'tofu init'"; exit 1;
fi

# Check tofu plan
if ! tofu plan &> /dev/null; then
  echo "tofu plan failed"; exit 1;
fi

# Check tofu apply (simulate with plan/apply dry-run)
if ! tofu apply -auto-approve &> /dev/null; then
  echo "tofu apply failed"; exit 1;
fi

# Check state file exists
if [ ! -f tofu.tfstate ] && [ ! -f terraform.tfstate ]; then
  echo "State file not found after apply"; exit 1;
fi

# Check tofu destroy
if ! tofu destroy -auto-approve &> /dev/null; then
  echo "tofu destroy failed"; exit 1;
fi

# Check container is destroyed
if docker ps --format '{{.Names}}' | grep -q 'tutorial-nginx'; then
  echo "Container 'tutorial-nginx' still running. Run 'tofu destroy'"; exit 1;
fi

echo "Task 4 verification passed!" 