# Windows image preparation for Glance

Refs:
- `https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2019`
- `https://winiso.com/`
- `https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso`
- `https://cloudbase.it/cloudbase-init/#download`
- `https://docs.openstack.org/image-guide/`
- `https://docs.openstack.org/image-guide/windows-image.html`

## Steps
```text
Download VHD version
Before starting VM: settings -> checkpoint dashboard -> uncheck "Enable checkpoint"
Install QEMU guest agent
Install virtio (64-bit)
sysdm.cpl -> enable remote desktop
Server Manager -> change time/time zone, disable IE enhanced security
PowerShell (admin): sconfig -> 5 -> M, then 4 -> 3 (enable ping)
Add role for ICMP
Cloudbase-Init wizard:
  - empty username, user metadata, group
  - run as LocalSystem
  - set serial to COM1
At the end: check both options (Run Sysprep and Shutdown)
```

## QEMU tools (optional)
```text
https://qemu.weilnetz.de/w64/qemu-w64-setup-20221230.exe
Add to PATH: C:\Program Files\qemu
```

## Convert and upload
```bash
qemu-img convert -p -O raw /mnt/e/Downloads/17763.737.amd64fre.rs5_release_svc_refresh.190906-2324_server_serverdatacentereval_en-us_1.vhd /mnt/e/Downloads/win2019v3.img

glance image-create --name "IMAGE_NAME" --file /PATH_TO_FILE --disk-format FORMAT --container-format bare --progress

glance image-create --name "Win2019-new" --file Windows2019.raw --disk-format raw --container-format bare --progress
```

Afterward, create an instance from this image and verify ping (virtio installed).
