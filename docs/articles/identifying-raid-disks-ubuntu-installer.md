# Identifying RAID Arrays and Physical Disks in Ubuntu Server Installer

## The Problem

When installing Ubuntu Server on a machine with a hardware RAID controller (e.g., HP Smart Array P440ar), the installer's disk selection screen shows all disks as generic "local disk" entries with cryptic SCSI IDs like `3600508b1001c21893...`. There is no indication of which disk is:

- A RAID array (mirrored SSDs) vs. a standalone HDD
- An SSD vs. a spinning disk
- An NVMe drive vs. a RAID logical volume

This makes it easy to accidentally install the OS on the wrong disk — wiping a data array or installing on a slow HDD instead of the fast RAID 1 SSD pair.

### Real-World Example

An HPE ProLiant DL360 Gen9 with:
- 2x Samsung EVO SSDs in RAID 1 (via P440ar) — intended for OS
- 1x standalone SATA HDD (1TB)
- 1x Samsung 990 PRO NVMe (direct, no RAID)
- Additional RAID array (3.6TB)

The Ubuntu installer showed:

```
3600508b1001c21893...    local disk    3.638T
3600508b1001cbf9e0...    local disk    1.091T
Samsung_SSD_990_PRO...   local disk    931.513G
3600508b1001c388e6...    local disk    931.482G
```

Only the NVMe drive shows its real name. The three RAID logical volumes are indistinguishable.

## The Solution

Drop to a shell during installation and use `lsblk` to inspect disk properties.

### Step 1: Open a Shell

Press **Alt+F2** during the Ubuntu Server installer to switch to a root shell. (Press **Alt+F1** to return to the installer.)

### Step 2: Identify Disks

Run:

```bash
lsblk -d -o NAME,SIZE,MODEL,ROTA
```

Output:

```
NAME      SIZE  MODEL              ROTA
sda     931.5G  LOGICAL VOLUME        0
sdb       3.6T  LOGICAL VOLUME        0
sdc       1.1T  LOGICAL VOLUME        1
nvme0n1 931.5G  Samsung SSD 990 PRO   0
```

### Understanding the Output

| Column | Meaning |
|--------|---------|
| `NAME` | Block device name (`sda`, `sdb`, `nvme0n1`, etc.) |
| `SIZE` | Usable capacity |
| `MODEL` | Disk model — `LOGICAL VOLUME` = behind a RAID controller |
| **`ROTA`** | **Rotational**: `0` = SSD/flash, `1` = spinning HDD |

**`ROTA` is the key column.** It tells you whether the underlying storage is solid-state or spinning:

- **ROTA=0** → SSD (or SSD-based RAID array)
- **ROTA=1** → HDD (spinning disk)

### Step 3: Cross-Reference with Size

Combine ROTA with size to identify each disk:

| Device | Size | ROTA | Identity |
|--------|------|------|----------|
| sda | 931.5G | 0 (SSD) | RAID 1 array (2x EVO SSDs) — **install OS here** |
| sdb | 3.6T | 0 (SSD) | Large RAID array (multiple SSDs) |
| sdc | 1.1T | 1 (HDD) | Standalone SATA spinning disk |
| nvme0n1 | 931.5G | 0 (SSD) | Direct NVMe SSD (not behind RAID controller) |

### Additional Commands

For more detail:

```bash
# Show SCSI device info (vendor, model, type)
cat /proc/scsi/scsi

# Show disk serial numbers and WWN
lsblk -d -o NAME,SIZE,MODEL,SERIAL,WWN,ROTA

# Show disk transport type
lsblk -d -o NAME,SIZE,TRAN,MODEL,ROTA
# TRAN values: sas, sata, nvme, usb

# Check RAID controller details (if ssacli/hpssacli is available)
ssacli ctrl all show config

# Show partition tables
fdisk -l /dev/sda
```

## Best Practices

1. **Always verify before partitioning.** Drop to shell and run `lsblk` — it takes 10 seconds and prevents costly mistakes.

2. **Install OS on the RAID 1 array** when available. RAID 1 provides redundancy — if one disk fails, the system keeps running.

3. **Prefer SSDs (ROTA=0) for OS.** Boot times and system responsiveness are dramatically better on SSD.

4. **NVMe vs. RAID SSD trade-off:**
   - NVMe: faster raw performance, no RAID overhead
   - RAID 1 SSD: redundancy (survives a disk failure)
   - For a server, RAID 1 is usually the better choice for the OS disk.

5. **Label your disks after install** to avoid future confusion:
   ```bash
   # Set filesystem label
   e2label /dev/sda2 "OS-RAID1"
   
   # Or use a GPT partition label
   sgdisk -c 2:"OS-RAID1" /dev/sda
   ```

## Applies To

- Ubuntu Server 20.04, 22.04, 24.04 (Subiquity installer)
- Any Linux installer with shell access
- HP Smart Array (P440ar, P840, etc.), Dell PERC, LSI MegaRAID controllers
- Any system where RAID logical volumes obscure physical disk identity
