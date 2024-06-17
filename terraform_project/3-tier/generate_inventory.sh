#!/bin/bash

# Extract the outputs from Terraform
PUBLIC_IP=$(terraform output -raw public_instance_public_ip)
PRIVATE_IP=$(terraform output -raw private_instance_private_ip)

# Create the Ansible inventory file
cat > inventory.ini <<EOF
[bastion]
public_instance ansible_host=${PUBLIC_IP} ansible_user=ubuntu ansible_ssh_private_key_file=/home/sameer/.ssh/my-key.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[private]
private-instance ansible_host=${PRIVATE_IP} 
ansible_user=ubuntu 
ansible_ssh_private_key_file=/home/sameer/.ssh/my-key.pem 
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[private:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q ubuntu@${PUBLIC_IP}"' ansible_ssh_private_key_file=/home/sameer/.ssh/my-key.pem  ansible_ssh_common_args='-o StrictHostKeyChecking=no'

EOF
