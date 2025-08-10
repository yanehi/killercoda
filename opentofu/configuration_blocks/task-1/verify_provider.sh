#!/bin/bash

# Create solution directory
mkdir -p ~/configuration_blocks/syntax-and-configuration/solution-1

# Create provider.tf file with the required content
cat > ~/configuration_blocks/syntax-and-configuration/solution-1/provider.tf << 'EOF'
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}
EOF

echo "Solution-1 created successfully!"
echo "Created provider.tf in ~/configuration_blocks/syntax-and-configuration/solution-1/"
