# Windows 2012 image preparation

Run Virt-Manager on the QEMU host machine and create a new VM:
- Local install media (ISO image or CDROM)

![1](https://user-images.githubusercontent.com/10008766/233982497-6fa88d60-74e1-4b36-8cb9-5699a517add4.png)

Copy the evaluation ISO to `/var/lib/libvirt/image`, then:
- Choose the image and leave "Automatically detect ..."

![2](https://user-images.githubusercontent.com/10008766/233982581-4dd1680c-09c1-4d23-9966-10c0070509df.png)

Disk setting:

![3](https://user-images.githubusercontent.com/10008766/233982600-664ab136-1079-4fac-ba75-d98e901e1613.png)

- Customize configuration before installation
- Set disk bus to SATA and begin installation

![Screenshot 2023-04-24 145135](https://user-images.githubusercontent.com/10008766/233982185-f3aff4f1-ebf3-4608-b68f-dad4a96db6dc.jpg)

- Leave disk unallocated

![4](https://user-images.githubusercontent.com/10008766/233982913-4a36c0fa-e7c7-4bc1-a25a-5099fd9c310f.png)

## Post-install steps
Run:

```text
sysdm.cpl
```

![image2023-4-5_11-10-3](https://user-images.githubusercontent.com/10008766/234252790-c18854e0-2446-436d-b2de-ee4458e333f7.png)

- Enable remote desktop

![image2023-4-5_11-10-59](https://user-images.githubusercontent.com/10008766/234252848-d2423840-19c2-44fa-ab3f-81bc331682a0.png)

Server Manager:
- Change time and time zone
- Disable IE Enhanced Security

![1](https://user-images.githubusercontent.com/10008766/234253052-43c3e0d8-9563-4ee3-963e-65e495028423.png)

PowerShell (admin):
```text
sconfig --> 5 --> M (Manual)
sconfig --> 4 --> 3 (enable ping)
```

![image2023-4-5_11-18-31](https://user-images.githubusercontent.com/10008766/234253223-3af986a7-4591-48fb-b1ef-9d4db903f95b.png)

Install Cloudbase-Init (if it fails, go to next step and try again):
- Stable version: https://cloudbase.it/cloudbase-init/
- Wizard: empty username, user metadata, group
- Run as LocalSystem and set serial to COM1

![image2023-4-5_11-51-5](https://user-images.githubusercontent.com/10008766/234253486-35f60a71-ea85-40cc-abe4-0fe7c21b8dbe.png)

At the end of the wizard, check both options (Run Sysprep and Shutdown).

![image2023-4-5_11-53-10](https://user-images.githubusercontent.com/10008766/234253526-b0959a15-cfc1-4a10-b893-f6d01ad9d0fe.png)

Final checks:
- Add a role for ICMPv4 in firewall settings
- Install QEMU guest agent
- Install virtio (64-bit)
- Run `sconfig` and use option 5, then `A` (all) updates
