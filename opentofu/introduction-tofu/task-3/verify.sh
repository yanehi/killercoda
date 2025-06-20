#!/bin/bash
set -e

# Check main.tf exists
if [ ! -f main.tf ]; then
  echo "main.tf not found"; exit 1;
fi

# Check resource blocks
if ! grep -q 'resource\s\+"docker_image"\s\+"nginx"' main.tf; then
  echo "docker_image.nginx resource not found"; exit 1;
fi
if ! grep -q 'resource\s\+"docker_container"\s\+"nginx"' main.tf; then
  echo "docker_container.nginx resource not found"; exit 1;
fi

# Check running container
if ! docker ps --format '{{.Names}}' | grep -q 'tutorial-nginx'; then
  echo "Container 'tutorial-nginx' is not running"; exit 1;
fi

echo "Task 3 verification passed!" 