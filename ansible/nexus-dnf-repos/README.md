# Nexus DNF Repos

Creates YUM/DNF proxy repositories in Sonatype Nexus and grants anonymous read access.

## Repos Created

| Name | Upstream |
|------|----------|
| almalinux-baseos | repo.almalinux.org/almalinux/9/BaseOS/x86_64/os/ |
| almalinux-appstream | repo.almalinux.org/almalinux/9/AppStream/x86_64/os/ |
| epel-proxy | dl.fedoraproject.org/pub/epel/9/Everything/x86_64/ |
| docker-ce | download.docker.com/linux/centos/ |

## Usage

```bash
export NEXUS_PASSWORD='your-nexus-admin-password'
ansible-playbook playbook.yml
```

Or override vars:

```bash
ansible-playbook playbook.yml -e nexus_url=https://nexus.example.com -e nexus_password=secret
```

## What it does

1. Checks if each repo already exists (idempotent)
2. Creates missing YUM proxy repos pointing to upstream mirrors
3. Adds read/browse privileges to the `anonymous-proxy-only` role
4. Verifies anonymous access to each repo's `repomd.xml`

## Requirements

- Ansible 2.9+
- Nexus 3.x with REST API enabled
- Admin credentials
- `anonymous-proxy-only` role (Cloudinative-specific; adjust role name if different)
