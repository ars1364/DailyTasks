# CloudLink Deployment (abreina.ir)

Deploy the CloudLink Next.js app with hardened nginx, free SSL (Let's Encrypt), Docker, and server hardening.

## What it does

1. Configures Cloudinative APT mirrors
2. Installs Docker via Cloudinative mirror script
3. Clones CloudLink repo and starts via `docker compose`
4. Installs and configures nginx as reverse proxy with SSL termination
5. Obtains free SSL cert from Let's Encrypt (auto-renewal via certbot timer)
6. Hardens server: UFW firewall, fail2ban, SSH key-only, kernel sysctl, auto-updates

## Usage

```bash
ansible-playbook -i inventory.yml playbook.yml
```

## Requirements

- Ubuntu 24.04 VM with public IP
- DNS A record pointing to the VM IP
- SSH access with sudo

## Hardening checklist

- [x] UFW: only 22, 80, 443 open
- [x] SSH: password auth disabled, root login disabled
- [x] fail2ban: 3 strikes -> 1h ban on SSH
- [x] Kernel: syncookies, rp_filter, no redirects, no source routing, log martians
- [x] Nginx: server_tokens off, rate limiting, security headers, HSTS
- [x] SSL: Let's Encrypt with auto-renewal, HTTPS redirect
- [x] Auto-updates: unattended-upgrades enabled
