# Nexus Bun Mirror

Localizes `curl -fsSL https://bun.sh/install | bash` through Cloudinative infrastructure.

## What It Does

1. **Nexus raw proxy** (`bun-github-releases`): proxies `https://github.com/oven-sh/bun/releases` for binary downloads
2. **Nexus raw hosted** (`bun-install`): hosts a modified install script that points to our mirror
3. **DNS**: `bun.cloudinative.com` A record -> 176.65.243.214
4. **Reverse proxy**: nginx config routing install script and GitHub release proxying

## Usage

```bash
export NEXUS_PASSWORD='Cl0ud1n@t1ve!Nxs2026'
ansible-playbook -i inventory.yml playbook.yml
```

## Client Usage (on target VMs)

```bash
curl -fsSL https://bun.cloudinative.com/install | bash
```

That's it. The install script and all binaries are served from our infra.

## Architecture

```
Client -> bun.cloudinative.com (RP 176.65.243.214)
  /install         -> Nexus raw hosted (bun-install/install.sh)
  /github/...      -> Nexus raw proxy  (bun-github-releases -> github.com)
```
