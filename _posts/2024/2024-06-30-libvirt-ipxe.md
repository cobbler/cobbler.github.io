---
layout: post
title: Cobbler on CentOS 9 with iPXE
author: Enno
summary: How to boot your libvirt VMs with iPXE.
---

This guide was created very quickly to help out GitHub user [sqsous](https://github.com/sqsous) in
[GitHub Discussion #3716](https://github.com/cobbler/cobbler/discussions/3716). As such it may contain a few more
grammar errors and spelling mistakes. As most guides covering this topic are outdated it felt right to publish it here. 

> SELinux is in the way per-default, for the purpose of this guide it will be treated as permissive.

Steps:

1. Download CentOS 9
2. Setup libvirt VM guest via ISO with
   - the e1000e network card: Fedora 17 can't handle virtio
   - a physical drive or dedicated partition: Fedora 17 can't handle virtio
3. dnf install epel-release
4. dnf install cobbler
5. dnf install dhcp-server tftp-server ipxe-bootimgs-x86
6. Disable selinux: Edit `/etc/selinux/config` and set `SELINUX=permissive`
7. reboot
8. Set the following settings:
   - `enable_ipxe: true`
   - `manage_dhcp: true`
   - `manage_dhcp_v4: true`
   - `next_server_v4: <your ip>`
   - `server: <ip of cobbler server>`
9. Edit the `dhcp.template` to fit your network range and add the iPXE config above all other
   ```
   ...
   match if substring (option vendor-class-identifier, 0, 9) = "PXEClient";

   # iPXE
   if exists user-class and option user-class = "iPXE" {
       filename "ipxe/default.ipxe";
   }
   else if option system-arch = 00:00 {
       filename "undionly.pxe";
   }
   # Legacy
   else if option system-arch = 00:00 {
   ...
   else if option system-arch = 00:06 {
   ...
   else if option system-arch = 00:02 {
   ```
10. Enable the Cobbler system daemon: `systemctl enable --now cobblerd`
11. Create network bootable bootloaders: `cobbler mkloaders`
12. Create the folders for the downloaded ISOs:
    - `mkdir /mnt/iso-files`
    - `mkdir /mnt/iso-mounted`
13. Download the Ubuntu 18.04 installer ISO: `wget http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/current/images/netboot/mini.iso`
14. Rename the installer to `ubuntu-18-04-cdinstall.iso`
15. Downloaded Fedora 17 DVD image: `wget https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/17/Fedora/x86_64/iso/Fedora-17-x86_64-DVD.iso`
16. Mount the ISOs via fstab
    ```
    /mnt/iso-files/Fedora-17-x86_64-DVD.iso /mnt/iso-mounted/fedora-17/ iso9660 loop,ro 0 0
    /mnt/iso-files/ubuntu-18-04-cdinstall.iso /mnt/iso-mounted/ubuntu-18-04/ iso9660 loop,ro 0 0
    ```
17. Apply the updated fstab file with: `systemctl daemon-reload`
18. Import Fedora: `cobbler import --name="fedora-17" --path="/mnt/iso-mounted/fedora-17"`
19. Import Ubuntu: `cobbler import --name="ubuntu-18-04" --path="/mnt/iso-mounted/ubuntu-18-04" --arch="x86_64"`
20. Fix bug [RedHat Bugzilla 1029978](https://bugzilla.redhat.com/show_bug.cgi?id=1029978) with adjusting the kernel options:
        `cobbler distro edit --name="fedora-17-x86_64" --kernel-options="tree=http://@@http_server@@/cblr/links/fedora-17-x86_64 inst.stage2=http://@@http_server@@/cblr/links/fedora-17-x86_64"`
21. cobbler sync
22. Start the TFTP server: `systemctl enable --now tftp.socket`
23. Configure the firewall: `firewall-cmd --add-service=http && firewall-cmd --add-service=tftp && firewall-cmd --runtime-to-permanent`
24. Comment out the mirror settings in `/var/lib/cobbler/templates/sample.seed`
25. Boot client via ipxe

At this point the clients should be able to install Fedora 17 and Ubuntu 18.04 LTS without any error messages and
without doing anything but selecting the OS in the iPXE boot menu.

---

P.S.: In case you find typos and/or grammar mistakes just [open an Issue](https://github.com/cobbler/cobbler.github.io/issues/new) or [open a PR](https://github.com/cobbler/cobbler.github.io/compare).

