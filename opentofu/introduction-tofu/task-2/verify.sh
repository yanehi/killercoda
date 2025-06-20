#!/bin/bash
set -e

# Check main.tf exists
if [ ! -f main.tf ]; then
  echo "main.tf not found"; exit 1;
fi

# Check provider block
if ! grep -q 'source\s*=\s*"kreuzwerker/docker"' main.tf; then
  echo "kreuzwerker/docker provider not configured"; exit 1;
fi

# Check tofu init
if [ ! -d .terraform ]; then
  echo ".terraform directory not found. Run 'tofu init'"; exit 1;
fi

echo "Task 2 verification passed!" 