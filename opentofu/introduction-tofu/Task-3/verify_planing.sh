#!/bin/bash

# Navigate to the target directory
cd ~/introduction-tofu/lifecycle-management

# Check if tfplan file exists
if [ -f "plan.tfplan" ]; then
    echo "✅ plan.tfplan file found"
else
    echo "❌ plan.tfplan file not found"
    exit 1
fi

