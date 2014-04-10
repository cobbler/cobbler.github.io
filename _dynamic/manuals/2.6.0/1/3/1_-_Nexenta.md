---
layout: manpage
title: Nexenta
meta: 2.6.0
---

## Installing NexentaStor with Cobbler

The following steps outline the Nexenta install process when using Cobbler.

1) Assuming that Cobbler has been setup previously, verify that the signature file contains the entry for Nexenta: 

{ highlight bash }
  "nexenta": {
    "4": {
      "signatures":["boot"],
      "version_file": "platform",
      "version_file_regex": null,
      "supported_arches":["x86_64"],
      "supported_repo_breeds":["apt"],
      "kernel_file":"platform/i86pc/kernel/amd64/unix",
      "initrd_file":"platform/i86pc/amd64/miniroot",
      "isolinux_ok":false,
      "kernel_options":"",
      "kernel_options_post":"",
      "boot_files":[]
    }
  }
{ endhighlight }

2) Obtain a Nexenta iso from http://www.nexenta.com/corp/nexentastor-download and mount it: 

{ highlight bash }
mkdir -p /mnt/nexenta4 && mnt /path/to/nexenta4.iso /mnt/nexenta4 -o loop`
{ endhighlight }

3) Import the distribution into Cobbler: 

{ highlight bash }
cobbler import --name=nexenta-4 --path=/mnt/nexenta4
{ endhighlight }

Verify that a Nexenta distirbution is available via Cobbler: cobbler list
Once the import is done, you can unmount the ISO: 

{ highlight bash }
sudo umount /mnt/nexenta4
{ endhighlight }

4) Nexenta uses a PXE Grub executable different from other, linux-like systems. To install a Nexenta on a desired system, you have to specify the PXE Grub file for that system. This can be done by using either a MAC address, or a subnet definition in your DHCP configuration file. In /etc/cobbler/dhcp.template:

{ highlight bash }
  host test-1 {
    hardware ethernet 00:0C:29:10:B6:10;
    fixed-address 10.3.30.91;
    filename "boot/grub/pxegrub";
  }
  host test-2 {
    hardware ethernet 00:0c:29:d1:9c:26;
    fixed-address 10.3.30.97;
    filename "boot/grub/pxegrub";
  }
{ endhighlight }

OR if you are installing only Nexenta on all machines on a subnet, you may use the subnet definition instead of host definition in your dhcp config file.

Note: the path `boot/grub/pxegrub` is a hardcoded default in the Nexenta boot process.

5) In order the have unmanned installation, an installation profile must be created for each booted Nexenta system. The profiles are placed in /var/lib/cobbler/kickstarts/install_profiles. Each profile should be a file with the filename `machine.AACC003355FF` where AA..FF stand for the mac address of the machine, without `:` (columns). The contents of each profile should look like the following:

{ highlight bash }
__PF_gateway="IP address" (required)
__PF_nic_primary="NIC NAME" (required)
__PF_dns_ip_1="IP address" (required)
__PF_dns_ip_2="IP address" (optional)
__PF_dns_ip_3="IP address" (optional)
__PF_loghost="IP address" (optional)
__PF_logport="Port Number" (optional)
__PF_syspool_luns="list of space separated LUNs that will be used to create syspool" (required)
__PF_syspool_spare="list of space separated LUNs that will be used as syspool spare" (optional)
__PF_ipaddr_NIC_NAME="IP address" (NIC_NAME is the name of the target NIC e1000g0, ixgbe1, etc.) (required)
__PF_netmask_NIC_NAME="NETMASK" (NIC_NAME is the name of the target NIC e1000g0, ixgbe1, etc.) (required)
__PF_nlm_key="LICENSE KEY" (required)
__PF_language="en" (used to choose localzation, but now only "en" is supported) (required)
__PF_ssh_enable=1 (enable SSH, by default SSH is disabled) (optional)
__PF_ssh_port="PORT where SSH server will wait for incoming connections" (optional)
{ endhighlight }

6) Power on the hardware. NexentaStor should boot from this setup. 

## Hints & Notes

This process has been tested with Cobbler Release 2.6.0 running on Ubuntu 12.04 LTS.

The install of Nexenta is automatic. That means that each machine to be booted with nexenta has to be configurated with a profile in kickstarts/install_profiles directory. To boot Nexenta nodes manually, in the file /var/lib/tftpboot/boot/grub/menu.lst replace the line:

{ highlight bash } 
    kernel$ /images/nexenta-a-x86_64/platform/i86pc/kernel/amd64/unix -B iso_nfs_path=10.3.30.95:/var/www/cobbler/links/nexenta-a-x86_64,auto_install=1
{ endhighlight }

With

{ highlight bash }
    kernel$ /images/nexenta-a-x86_64/platform/i86pc/kernel/amd64/unix -B iso_nfs_path=10.3.30.95:/var/www/cobbler/links/nexenta-a-x86_64
{ endhighlight }

If you are adding a new distro, don't forget to enable NFS access to it! NFS share must be configured on the boot server. In particular, the directories in /var/www/cobbler/links/<distro-name> are exported. As an example, there is a /etc/exports file:

{ highlight bash }
# /etc/exports: the access control list for filesystems which may be exported
#    to NFS clients.  See exports(5).
#
# Example for NFSv2 and NFSv3:
# /srv/homes       hostname1(rw,sync,no_subtree_check) hostname2(ro,sync,no_subtree_check)
#
# Example for NFSv4:
# /srv/nfs4        gss/krb5i(rw,sync,fsid=0,crossmnt,no_subtree_check)
# /srv/nfs4/homes  gss/krb5i(rw,sync,no_subtree_check)
#
/var/www/cobbler/links/nexenta-a-x86_64 *(ro,sync,no_subtree_check)
/var/www/cobbler/links/<nexenta-distribution-name> *(ro,sync,no_subtree_check)
{ endhighlight }

