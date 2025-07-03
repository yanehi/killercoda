#!/bin/bash
set -e

# Check variables.tf, outputs.tf, and locals.tf exist
if [ ! -f variables.tf ]; then
  echo "variables.tf not found"; exit 1;
fi
if [ ! -f outputs.tf ]; then
  echo "outputs.tf not found"; exit 1;
fi
if [ ! -f locals.tf ]; then
  echo "locals.tf not found"; exit 1;
fi

# Check files are not empty
if [ ! -s variables.tf ]; then
  echo "variables.tf is empty"; exit 1;
fi
if [ ! -s outputs.tf ]; then
  echo "outputs.tf is empty"; exit 1;
fi
if [ ! -s locals.tf ]; then
  echo "locals.tf is empty"; exit 1;
fi

# Check tofu fmt
if ! tofu fmt -check -diff; then
  echo "Formatting issues found"; exit 1;
fi

echo "Task 6 verification passed!" 