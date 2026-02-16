# Git Cache Proxy

Deploys `git-cache-http-server` on the artifact VM to transparently cache Git repositories from GitHub (and any other Git host).

## What It Does

1. **Artifact VM (10.20.0.40)**: Installs `git-cache-http-server` via npm, runs as systemd service on port 8181
2. **DNS**: `git.cloudinative.com` A record -> 176.65.243.214
3. **Reverse Proxy**: nginx proxies HTTPS to the cache server

## How It Works

- First `git clone` -> fetches from upstream (GitHub), caches locally in `/var/cache/git`
- Subsequent clones/fetches -> served from cache if revision matches
- If upstream has new commits -> fetches new data, updates cache
- Works offline for cached repos (serves last known revision)

## Usage

```bash
export NEXUS_PASSWORD='Cl0ud1n@t1ve!Nxs2026'  # for artifact VM access
ansible-playbook -i inventory.yml playbook.yml
```

## Client Usage

### One-off clone
```bash
git clone https://git.cloudinative.com/github.com/ars1364/SNIProxy.git
```

### Global transparent proxy (all HTTPS git ops go through cache)
```bash
git config --global url."https://git.cloudinative.com/".insteadOf https://
```

After that, `git clone https://github.com/anything/repo.git` transparently uses the cache.

### Undo global config
```bash
git config --global --unset url."https://git.cloudinative.com/".insteadOf
```
