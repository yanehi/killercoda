#!/bin/bash
set -e

# Check tofu state list
if ! tofu state list &> /dev/null; then
  echo "tofu state list failed"; exit 1;
fi

# Check tofu state show (example resource)
if ! tofu state show docker_container.nginx &> /dev/null; then
  echo "tofu state show for docker_container.nginx failed"; exit 1;
fi

# Check tofu import command is available
if ! tofu import --help &> /dev/null; then
  echo "tofu import command not available"; exit 1;
fi

# Check tofu state mv command is available
if ! tofu state mv --help &> /dev/null; then
  echo "tofu state mv command not available"; exit 1;
fi

# Check tofu state rm command is available
if ! tofu state rm --help &> /dev/null; then
  echo "tofu state rm command not available"; exit 1;
fi

# Check tofu destroy command is available
if ! tofu destroy --help &> /dev/null; then
  echo "tofu destroy command not available"; exit 1;
fi

echo "Task 5 verification passed!" 