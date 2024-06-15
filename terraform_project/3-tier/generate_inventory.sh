#!/bin/bash

# Extract the outputs from Terraform
PUBLIC_IP=$(terraform output -raw public_instance_public_ip)
PRIVATE_IP=$(terraform output -raw private_instance_private_ip)

# Debugging: Print the extracted values
echo "Public IP: ${PUBLIC_IP}"
echo "Private IP: ${PRIVATE_IP}"

# Create the Ansible inventory file
cat > inventory.ini <<EOF
[public]
public_instance ansible_host=${PUBLIC_IP} ansible_user=ubuntu 

[private]
private-instance ansible_host=${PRIVATE_IP} ansible_user=ubuntu 

[private:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q ubuntu@${PUBLIC_IP}"'

EOF

# Debugging: Confirm the inventory file creation
echo "inventory.ini file created successfully."
