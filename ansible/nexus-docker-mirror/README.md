# Nexus Docker Mirror Setup

Ansible playbook to configure Nexus Repository Manager as a Docker CE mirror,
providing `apt` and `yum` proxy repos so machines can install Docker without
reaching `download.docker.com` directly.

## What it does

1. **Nexus repos** – creates `docker-ce` (raw proxy → download.docker.com) and
   `docker-gpg` (raw hosted) repositories via the Nexus REST API.
2. **GPG key** – downloads Docker's official GPG key and uploads it to `docker-gpg`.
3. **Install script** – downloads `get.docker.com`, patches the download URL to
   point at the local mirror, and uploads it to `docker-gpg`.
4. **Anonymous access** – adds read/browse privileges for the new repos to the
   anonymous role so clients don't need credentials.
5. **Nginx** – adds location blocks on the artifact VM so
   `apt.cloudinative.com/repository/docker-ce/` and
   `apt.cloudinative.com/repository/docker-gpg/` are routed to Nexus.

## Usage

```bash
# From the repo root
ansible-playbook ansible/nexus-docker-mirror/playbook.yml -i ansible/nexus-docker-mirror/inventory.yml
```

## End-user install command

```bash
curl -fsSL https://apt.cloudinative.com/repository/docker-gpg/get-docker.sh | bash
```

Works on Ubuntu, Debian, CentOS, RHEL, Fedora.

## Variables

See `vars.yml` for configurable values (Nexus URL, credentials, mirror URL, etc.).
