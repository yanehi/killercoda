#!/bin/bash

# Navigate to the target directory
cd ~/introduction-tofu/lifecycle-management

# Check if tfplan file exists
if [ -f "tfplan" ]; then
    echo "✅ tfplan file found"
else
    echo "❌ tfplan file not found"
    exit 1
fi

