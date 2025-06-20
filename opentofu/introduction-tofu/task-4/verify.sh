#!/bin/bash
set -e

# Check tofu state list
if ! tofu state list &> /dev/null; then
  echo "tofu state list failed"; exit 1;
fi

# Check tofu state show
if ! tofu state show docker_container.nginx &> /dev/null; then
  echo "tofu state show for docker_container.nginx failed"; exit 1;
fi

# Check container is destroyed
if docker ps --format '{{.Names}}' | grep -q 'tutorial-nginx'; then
  echo "Container 'tutorial-nginx' still running. Run 'tofu destroy'"; exit 1;
fi

echo "Task 4 verification passed!" 