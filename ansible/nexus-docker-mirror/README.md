# Nexus Artifact Mirror Setup

Ansible playbook to configure Nexus Repository Manager as a clean mirror for:
- **Ubuntu APT** (archive + security)
- **Docker CE** (packages + GPG key)
- **Docker Registry** (image pull mirror)

## Clean URL Mapping

Users just swap the public domain with `*.cloudinative.com` — the path stays identical:

| Original | Mirror |
|---|---|
| `archive.ubuntu.com/ubuntu/` | `archive.cloudinative.com/ubuntu/` |
| `security.ubuntu.com/ubuntu/` | `security.cloudinative.com/ubuntu/` |
| `download.docker.com/linux/ubuntu` | `download.cloudinative.com/linux/ubuntu` |
| `registry-1.docker.io` | `docker.cloudinative.com` |

## Usage

```bash
ansible-playbook playbook.yml -i inventory.yml

# Override nexus password:
NEXUS_ADMIN_PASSWORD=secret ansible-playbook playbook.yml -i inventory.yml
```

## Variables

See `vars.yml` for configurable values (Nexus URL, credentials, domain, etc.).

## DNS Requirements

These DNS records must point to the reverse proxy (176.65.243.214):

```
archive.cloudinative.com   A  176.65.243.214
security.cloudinative.com  A  176.65.243.214
download.cloudinative.com  A  176.65.243.214
docker.cloudinative.com    A  176.65.243.214
```

SSL is handled by the wildcard `*.cloudinative.com` certificate.

---

## Client Configuration Guide

### Ubuntu APT Sources

Replace `/etc/apt/sources.list.d/ubuntu.sources` with:

```
Types: deb
URIs: https://archive.cloudinative.com/ubuntu/
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: https://security.cloudinative.com/ubuntu/
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
```

Or as one-liner for older `sources.list` format:

```bash
cat <<'EOF' | sudo tee /etc/apt/sources.list
deb https://archive.cloudinative.com/ubuntu/ noble main restricted universe multiverse
deb https://archive.cloudinative.com/ubuntu/ noble-updates main restricted universe multiverse
deb https://archive.cloudinative.com/ubuntu/ noble-backports main restricted universe multiverse
deb https://security.cloudinative.com/ubuntu/ noble-security main restricted universe multiverse
EOF
```

Then run:

```bash
sudo apt-get update
```

### Docker CE Installation

**Option A: Manual (recommended)**

```bash
# 1. Add Docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.cloudinative.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 2. Add Docker APT repo
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.cloudinative.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# 3. Install
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

**Option B: One-liner install script**

```bash
DOWNLOAD_URL=https://download.cloudinative.com bash <(curl -fsSL https://get.docker.com)
```

### Docker Registry Mirror

Add to `/etc/docker/daemon.json`:

```json
{
  "registry-mirrors": ["https://docker.cloudinative.com"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

Then restart Docker:

```bash
sudo systemctl restart docker
```

Verify:

```bash
docker info | grep -A2 "Registry Mirrors"
```

### All-in-One Setup Script

For a fresh Ubuntu 24.04 server, run:

```bash
#!/bin/bash
set -e

# APT mirrors
sudo tee /etc/apt/sources.list.d/ubuntu.sources > /dev/null <<'EOF'
Types: deb
URIs: https://archive.cloudinative.com/ubuntu/
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: https://security.cloudinative.com/ubuntu/
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

# Docker CE
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.cloudinative.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.cloudinative.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker registry mirror
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json > /dev/null <<'EOF'
{
  "registry-mirrors": ["https://docker.cloudinative.com"],
  "log-driver": "json-file",
  "log-opts": { "max-size": "10m", "max-file": "3" }
}
EOF
sudo systemctl restart docker

echo "Done. All repos pointing to *.cloudinative.com mirrors."
```
