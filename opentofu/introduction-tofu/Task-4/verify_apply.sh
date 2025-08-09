#!/bin/bash

# Navigate to the target directory
cd ~/introduction-tofu/lifecycle-management

# Check if terraform.tfstate file exists (created after apply)
if [ -f "terraform.tfstate" ]; then
    echo "✅ terraform.tfstate file found"
else
    echo "❌ terraform.tfstate file not found - apply may not have been executed"
    exit 1
fi

# Check if Docker container with name "web-server" exists and is running
if docker ps --filter "name=web-server" --format "table {{.Names}}" | grep -q "web-server"; then
    echo "✅ Docker container 'web-server' is running"
else
    echo "❌ Docker container 'web-server' is not running"
    exit 1
fi
