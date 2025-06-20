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

# Check output variable
if ! grep -q 'output\s\+"message"' main.tf && [ ! -f outputs.tf ] && ! grep -q 'output\s\+"message"' outputs.tf; then
  echo "Output variable 'message' not found"; exit 1;
fi

echo "Task 1 verification passed!" 