#!/bin/bash

# Extract the outputs from Terraform
PUBLIC_IP=$(terraform output -raw public_instance_public_ip)
PRIVATE_IP=$(terraform output -raw private_instance_private_ip)

# Create the Ansible inventory file
cat > inventory.ini <<EOF
[public]
public_instance ansible_host=${PUBLIC_IP} ansible_user=ubuntu ansible_ssh_private_key_file=/home/sameer/.ssh/my-key.pem

[private]
private-instance ansible_host=${PRIVATE_IP} ansible_user=ubuntu ansible_ssh_private_key_file=/home/sameer/.ssh/my-key.pem

[private:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q ec2-user@${PUBLIC_IP} -i /home/sameer/.ssh/my-key.pem"'

EOF
