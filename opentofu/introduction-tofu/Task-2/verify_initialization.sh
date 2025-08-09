#!/bin/bash

# Navigate to the target directory
cd ~/introduction-tofu/lifecycle-management

# Check if .terraform directory exists
if [ -d ".terraform" ]; then
    echo "✅ .terraform directory found"
else
    echo "❌ .terraform directory not found"
    exit 1
fi

# Check if .terraform.lock.hcl file exists
if [ -f ".terraform.lock.hcl" ]; then
    echo "✅ .terraform.lock.hcl file found"
else
    echo "❌ .terraform.lock.hcl file not found"
    exit 1
fi
