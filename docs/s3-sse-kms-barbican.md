# S3 Server-Side Encryption with KMS (Barbican)

## Overview

Server-Side Encryption with KMS (SSE-KMS) encrypts S3 objects at rest using encryption keys managed by OpenStack Barbican (key management service). Objects are encrypted on upload and transparently decrypted on download.

### Architecture

```
Client (S3 PUT) → Ceph RGW → Barbican (fetch key) → Encrypt → Store on Ceph OSD
Client (S3 GET) → Ceph RGW → Barbican (fetch key) → Decrypt → Return plaintext
```

### Components

| Component | Role | Where |
|-----------|------|-------|
| **Ceph RGW** | S3-compatible object gateway, performs encryption/decryption | server05 (port 9000) |
| **Barbican** | OpenStack secret management service, stores encryption keys | server01-03 (port 9311) |
| **Keystone** | Authentication — RGW authenticates to Barbican via Keystone | server01-03 (port 5000) |
| **nginx proxy** | TLS termination for s3.cloudinative.com | 46.245.69.217 → 172.40.30.25:9000 |

### Encryption Modes

| Mode | Client Change | How |
|------|--------------|-----|
| **Per-object** | Client adds SSE headers to PUT | `x-amz-server-side-encryption: aws:kms` + key ID |
| **Default bucket encryption** | None (transparent) | Admin sets default encryption policy on bucket |

## Configuration

### Prerequisites
- Barbican enabled in Kolla: `enable_barbican: "yes"` in `/etc/kolla/globals.yml`
- Barbican running on all 3 nodes (api, worker, keystone_listener)
- Ceph RGW deployed via cephadm

### Step 1: Create Keystone Service User

RGW needs a Keystone user to authenticate to Barbican and fetch encryption keys.

```bash
# Via OpenStack CLI or API
openstack user create rgw_barbican --password 'RgwB@rb1c4n!2026Sec' --domain Default
openstack role add --project service --user rgw_barbican admin
```

### Step 2: Configure Ceph RGW

```bash
# Set KMS backend to Barbican
sudo cephadm shell -- ceph config set client.rgw.milad rgw_crypt_s3_kms_backend barbican

# Barbican endpoint (use internal HTTP to avoid SSL issues)
sudo cephadm shell -- ceph config set client.rgw.milad rgw_barbican_url http://172.30.204.10:9311

# Keystone auth for RGW → Barbican
sudo cephadm shell -- ceph config set client.rgw.milad rgw_keystone_url http://172.30.204.10:5000
sudo cephadm shell -- ceph config set client.rgw.milad rgw_keystone_admin_user rgw_barbican
sudo cephadm shell -- ceph config set client.rgw.milad rgw_keystone_admin_password RgwB@rb1c4n!2026Sec
sudo cephadm shell -- ceph config set client.rgw.milad rgw_keystone_admin_project service
sudo cephadm shell -- ceph config set client.rgw.milad rgw_keystone_admin_domain Default
sudo cephadm shell -- ceph config set client.rgw.milad rgw_keystone_api_version 3
sudo cephadm shell -- ceph config set client.rgw.milad rgw_keystone_verify_ssl false

# Barbican-specific auth (for key retrieval)
sudo cephadm shell -- ceph config set client.rgw.milad rgw_keystone_barbican_user rgw_barbican
sudo cephadm shell -- ceph config set client.rgw.milad rgw_keystone_barbican_password RgwB@rb1c4n!2026Sec
sudo cephadm shell -- ceph config set client.rgw.milad rgw_keystone_barbican_project service
sudo cephadm shell -- ceph config set client.rgw.milad rgw_keystone_barbican_domain Default

# Allow encryption over HTTP (internal traffic)
sudo cephadm shell -- ceph config set client.rgw.milad rgw_crypt_require_ssl false

# Restart RGW
sudo cephadm shell -- ceph orch restart rgw.milad
```

### Step 3: Create Encryption Key in Barbican

```bash
# Via OpenStack CLI
openstack secret store \
  --name "s3-default-kms-key" \
  --algorithm AES \
  --bit-length 256 \
  --mode CBC \
  --secret-type symmetric \
  --payload-content-type application/octet-stream \
  --payload-content-encoding base64 \
  --payload "$(openssl rand -base64 32)"

# Note the secret UUID (e.g., 1ad1865f-a2a9-4b7b-998f-65bae46c2dc3)
```

### Step 4: Test Encrypted Upload

```python
import boto3
from botocore.config import Config

s3 = boto3.client('s3',
    endpoint_url='https://s3.cloudinative.com',
    aws_access_key_id='YOUR_ACCESS_KEY',
    aws_secret_access_key='YOUR_SECRET_KEY',
    config=Config(s3={'addressing_style': 'path'}))

# Upload with SSE-KMS
s3.put_object(
    Bucket='my-bucket',
    Key='secret-file.txt',
    Body=b'confidential data',
    ServerSideEncryption='aws:kms',
    SSEKMSKeyId='1ad1865f-a2a9-4b7b-998f-65bae46c2dc3')

# Download (decrypted transparently)
obj = s3.get_object(Bucket='my-bucket', Key='secret-file.txt')
print(obj['Body'].read())  # b'confidential data'
```

### Step 5: Set Default Bucket Encryption (Transparent Mode)

```bash
aws --endpoint-url https://s3.cloudinative.com s3api put-bucket-encryption \
  --bucket my-bucket \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "aws:kms",
        "KMSMasterKeyID": "1ad1865f-a2a9-4b7b-998f-65bae46c2dc3"
      }
    }]
  }'
```

After this, all uploads to the bucket are encrypted automatically. No client-side changes needed.

## Verification

### Verify config is applied
```bash
sudo cephadm shell -- ceph config dump | grep -iE "rgw_crypt|barbican|keystone"
```

### Verify RGW is running
```bash
sudo cephadm shell -- ceph orch ps --service-name rgw.milad
```

### Verify encryption on an object
```bash
aws --endpoint-url https://s3.cloudinative.com s3api head-object \
  --bucket my-bucket --key secret-file.txt
# Look for ServerSideEncryption: aws:kms and SSEKMSKeyId in output
```

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| `Failed to retrieve the actual key` | RGW can't reach Barbican | Use internal HTTP URLs (172.30.204.10), not HTTPS |
| `InvalidArgument` on upload | Wrong key ID or key not in Barbican | Verify secret exists: `openstack secret list` |
| SSL errors | HTTPS between RGW and Keystone/Barbican | Set `rgw_keystone_verify_ssl false` or use HTTP internal endpoints |
| 403 on key retrieval | rgw_barbican user lacks permissions | Ensure admin role on service project |

## Security Notes

- Encryption keys never leave Barbican; RGW fetches them per-request
- Keys are stored encrypted in Barbican's database (using its own KEK)
- In-transit: HTTPS from client to nginx proxy; HTTP internally (trusted network)
- At-rest: objects encrypted with AES-256 on Ceph OSDs
- Per-customer key isolation: create separate Barbican secrets per customer
- Key rotation: create new key, re-encrypt objects (RGW does not auto-rotate)

## Ceph RGW Config Reference

| Config Key | Value | Purpose |
|------------|-------|---------|
| `rgw_crypt_s3_kms_backend` | `barbican` | Use Barbican for KMS |
| `rgw_barbican_url` | `http://172.30.204.10:9311` | Barbican API endpoint |
| `rgw_keystone_url` | `http://172.30.204.10:5000` | Keystone auth endpoint |
| `rgw_keystone_barbican_user` | `rgw_barbican` | Service user for Barbican |
| `rgw_keystone_barbican_password` | (secret) | Service user password |
| `rgw_keystone_barbican_project` | `service` | Keystone project scope |
| `rgw_keystone_barbican_domain` | `Default` | Keystone domain |
| `rgw_keystone_verify_ssl` | `false` | Skip SSL verification (internal) |
| `rgw_crypt_require_ssl` | `false` | Allow encryption over HTTP |
