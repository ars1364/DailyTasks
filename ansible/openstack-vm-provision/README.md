# OpenStack VM Provisioning

Ansible playbook to create Ubuntu VMs on Cloudinative OpenStack with boot-from-volume, floating IP, security groups, and Cloudinative APT mirror configuration.

## Usage

```bash
ansible-playbook -i inventory.yml playbook.yml -e "vm_name=abreina"
```

## Variables (group_vars/all.yml)

- `vm_name`: VM name
- `vm_flavor`: Flavor name (default: C2R4)
- `vm_image`: Glance image name (default: Ubuntu24)
- `vm_volume_size`: Boot volume size in GB (default: 25)
- `vm_network`: Network name (default: k8s-network)
- `vm_keypair`: Keypair name (default: mac-admin)
- `os_project`: OpenStack project (default: VPC_ARS)
- `assign_fip`: Whether to assign a floating IP (default: true)
