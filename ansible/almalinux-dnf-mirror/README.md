# AlmaLinux DNF Mirror Configuration

This Ansible playbook configures AlmaLinux VMs to use internal DNF and Docker mirrors hosted on cloudinative.com infrastructure.

## Components

- **DNF Repositories**: AlmaLinux BaseOS, AppStream, and EPEL proxy repositories
- **Docker Mirror**: Internal Docker registry mirror
- **Package Installation**: Automated installation of docker-ce, postgresql, nginx, redis

## Prerequisites

1. DNF proxy repositories must be created in Nexus:
   - almalinux-baseos → https://repo.almalinux.org/almalinux/9/BaseOS/x86_64/os/
   - almalinux-appstream → https://repo.almalinux.org/almalinux/9/AppStream/x86_64/os/
   - epel-proxy → https://dl.fedoraproject.org/pub/epel/

2. DNS record for dnf.cloudinative.com pointing to reverse proxy (176.65.243.214)

3. Reverse proxy configured to route DNF requests to Nexus (10.20.0.40:8081)

## Usage

```bash
ansible-playbook -i inventory configure-almalinux-mirrors.yml
```

## Repository Configuration Files

The playbook creates these repository files:

- `/etc/yum.repos.d/almalinux-baseos.repo`
- `/etc/yum.repos.d/almalinux-appstream.repo`
- `/etc/yum.repos.d/epel.repo`

## Docker Configuration

- Creates `/etc/docker/daemon.json` with internal registry mirrors
- Enables Docker service
- Tests pulling images from internal mirror

## Verification

The playbook includes verification steps to ensure all packages are installed from internal mirrors only.