# Nexus NodeSource APT Proxy

Adds a NodeSource Node.js 22.x APT proxy repository to Sonatype Nexus, creates the DNS subdomain, and configures the reverse proxy.

## What It Does

1. **Nexus**: Creates an APT proxy repo (`nodesource-node22`) mirroring `https://deb.nodesource.com/node_22.x`
2. **DNS**: Adds `nodejs.cloudinative.com` A record pointing to 176.65.243.214 (reverse proxy)
3. **Reverse Proxy**: Adds nginx config to proxy `nodejs.cloudinative.com` to artifact VM (10.20.0.40)
4. **Anonymous Access**: Grants read/browse privileges to the `anonymous-proxy-only` role

## Prerequisites

- Ansible 2.9+
- SSH access to DNS server (46.245.69.222) and reverse proxy (via ProxyCommand through DNS)
- Nexus admin credentials

## Usage

```bash
export NEXUS_PASSWORD='Cl0ud1n@t1ve!Nxs2026'
ansible-playbook -i inventory.yml playbook.yml
```

## Client Usage (on target VMs)

After setup, install Node.js 22 via the proxy:

```bash
# Import NodeSource GPG key (served from our infra)
curl -fsSL https://nodejs.cloudinative.com/gpg/nodesource-repo.gpg.key | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg

# Add repo pointing to our proxy
echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://nodejs.cloudinative.com/ nodistro main" > /etc/apt/sources.list.d/nodesource.list

apt-get update && apt-get install -y nodejs
```

## Infrastructure

| Component | Host | Access |
|-----------|------|--------|
| Nexus | 10.20.0.40 (artifact) | via https://artifact.cloudinative.com |
| DNS | 46.245.69.222 | SSH direct |
| Reverse Proxy | 10.20.0.10 / 176.65.243.214 | SSH via ProxyCommand through DNS |
