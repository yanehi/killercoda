#!/bin/bash

# Navigate to the target directory
cd ~/introduction-tofu/lifecycle-management

# Check if Docker container with name "web-server" does NOT exist (should be destroyed)
if docker ps --filter "name=web-server" --format "table {{.Names}}" | grep -q "web-server"; then
    echo "❌ Docker container 'web-server' is still running - destroy failed"
    exit 1
else
    echo "✅ Docker container 'web-server' is not running (correctly destroyed)"
fi