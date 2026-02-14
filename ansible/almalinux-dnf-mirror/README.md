# AlmaLinux DNF Mirror Setup

Configures AlmaLinux 9 VMs to use Cloudinative's internal Nexus mirrors exclusively. No public repos.

## What it does

1. Adds `/etc/hosts` entries for *.cloudinative.com (until DNS propagates)
2. Replaces all default repos with internal mirrors (baseos, appstream, epel, docker-ce)
3. Installs nginx, redis, postgresql-server via DNF
4. Installs Docker CE from internal mirror
5. Configures Docker to pull from docker.cloudinative.com
6. Pulls nginx, redis, postgres images
7. Verifies zero public repos in use

## Prerequisites

- Run `../nexus-dnf-repos/playbook.yml` first to create repos in Nexus
- `dnf.cloudinative.com` and `docker.cloudinative.com` configured on reverse proxy
- Target VM accessible via SSH (directly or via jump host)

## Usage

```bash
# Edit inventory with your VM IPs
ansible-playbook -i inventory playbook.yml
```

## Mirror URLs

| Repo | Internal URL |
|------|-------------|
| BaseOS | https://dnf.cloudinative.com/almalinux-baseos/ |
| AppStream | https://dnf.cloudinative.com/almalinux-appstream/ |
| EPEL 9 | https://dnf.cloudinative.com/epel-proxy/ |
| Docker CE | https://dnf.cloudinative.com/docker-ce/linux/centos/$releasever/$basearch/stable/ |
| Docker Registry | https://docker.cloudinative.com |
