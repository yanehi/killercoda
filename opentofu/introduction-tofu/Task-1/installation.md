To complete the following tasks, an installation of OpenTofu is required. 
The official way to install OpenTofu on your desired operating system can be found in the 
official [OpenTofu Installation Guide](https://opentofu.org/docs/intro/install/).

The OpenTofu CLI contains the relevant commands to provision the desired target infrastructure from IaC scripts
and interact with the OpenTofu State (a file that describes the current state of the infrastructure).

## Task
Within the Killercoda scenarios, we are working in an Ubuntu 22.04 environment. 
To install OpenTofu, the following commands can be used:

```shell
# Update packages
apt-get update -y
# Download the installer script:
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
chmod +x install-opentofu.sh
./install-opentofu.sh --install-method deb
# Remove the installer:
rm -f install-opentofu.sh
```{{exec}}

To verify that OpenTofu was installed correctly, the following command can be used:

```shell
tofu -version
```{{exec}}
