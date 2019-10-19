---
layout: manpage
title: 1 - Nexenta
meta: 2.6.0
nav: 1 - Nexenta
navversion: nav26
---

##Installing NexentaStor with Cobbler

The following steps outline the Nexenta install process when using Cobbler.

1) Assuming that Cobbler has been setup previously, verify that the signature file contains the entry for Nexenta:

````
"nexenta": {
    &quot;4&quot;: {
      &quot;signatures&quot;:[&quot;boot&quot;],
      &quot;version_file&quot;: &quot;platform&quot;,
      &quot;version_file_regex&quot;: null,
      &quot;supported_arches&quot;:[&quot;x86_64&quot;],
      &quot;supported_repo_breeds&quot;:[&quot;apt&quot;],
      &quot;kernel_file&quot;:&quot;platform/i86pc/kernel/amd64/unix&quot;,
      &quot;initrd_file&quot;:&quot;platform/i86pc/amd64/miniroot&quot;,
      &quot;isolinux_ok&quot;:false,
      &quot;kernel_options&quot;:&quot;&quot;,
      &quot;kernel_options_post&quot;:&quot;&quot;,
      &quot;boot_files&quot;:[]
    }
  }
````

2) Obtain a Nexenta iso from http://www.nexenta.com/corp/nexentastor-download and mount it:

````bash
mkdir -p /mnt/nexenta4 && mnt /path/to/nexenta4.iso /mnt/nexenta4 -o loop
````

3) Import the distribution into Cobbler:

````
cobbler import --name=nexenta-4 --path=/mnt/nexenta4
````

Verify that a Nexenta distirbution is available via Cobbler: cobbler list
Once the import is done, you can unmount the ISO:

````bash
sudo umount /mnt/nexenta4
````

4) Nexenta uses a PXE Grub executable different from other, linux-like systems. To install a Nexenta on a desired
system, you have to specify the PXE Grub file for that system. This can be done by using either a MAC address, or a
subnet definition in your DHCP configuration file. In `/etc/cobbler/dhcp.template`:

````
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
````

OR if you are installing only Nexenta on all machines on a subnet, you may use the subnet definition instead of host
definition in your dhcp config file.

Note: the path `boot/grub/pxegrub` is a hardcoded default in the Nexenta boot process.

5) In order the have unmanned installation, an installation profile must be created for each booted Nexenta system. The
profiles are placed in `/var/lib/cobbler/kickstarts/install_profiles`. Each profile should be a file with the filename
`machine.AACC003355FF` where AA..FF stand for the mac address of the machine, without <code>:</code> (columns). The
contents of each profile should look like the following:

````
PF_gateway="IP address" (required)
PF_nic_primary="NIC NAME" (required)
PF_dns_ip_1="IP address" (required)
PF_dns_ip_2="IP address" (optional)
PF_dns_ip_3="IP address" (optional)
PF_loghost="IP address" (optional)
PF_logport="Port Number" (optional)
PF_syspool_luns="list of space separated LUNs that will be used to create syspool" (required)
PF_syspool_spare="list of space separated LUNs that will be used as syspool spare" (optional)
PF_ipaddr_NIC_NAME="IP address" (NIC_NAME is the name of the target NIC e1000g0, ixgbe1, etc.) (required)
PF_netmask_NIC_NAME="NETMASK" (NIC_NAME is the name of the target NIC e1000g0, ixgbe1, etc.) (required)
PF_nlm_key="LICENSE KEY" (required)
PF_language="en" (used to choose localzation, but now only &quot;en&quot; is supported) (required)
PF_ssh_enable=1 (enable SSH, by default SSH is disabled) (optional)
__PF_ssh_port="PORT where SSH server will wait for incoming connections" (optional)
````

6) Power on the hardware. NexentaStor should boot from this setup.

## Hints & Notes

This process has been tested with Cobbler Release 2.6.0 running on Ubuntu 12.04 LTS.

The install of Nexenta is automatic. That means that each machine to be booted with nexenta has to be configurated with
a profile in kickstarts/install_profiles directory. To boot Nexenta nodes manually, in the file 
`/var/lib/tftpboot/boot/grub/menu.lst` replace the line:

````bash
kernel$ /images/nexenta-a-x86_64/platform/i86pc/kernel/amd64/unix -B iso_nfs_path=10.3.30.95:/var/www/cobbler/links/nexenta-a-x86_64,auto_install=1
````

With

````bash
kernel$ /images/nexenta-a-x86_64/platform/i86pc/kernel/amd64/unix -B iso_nfs_path=10.3.30.95:/var/www/cobbler/links/nexenta-a-x86_64
````

If you are adding a new distro, don't forget to enable NFS access to it! NFS share must be configured on the boot
server. In particular, the directories in /var/www/cobbler/links/<distro-name> are exported. As an example, there is a
/etc/exports file:

````
# /etc/exports: the access control list for filesystems which may be exported

to NFS clients.  See exports(5).

#

Example for NFSv2 and NFSv3:

/srv/homes       hostname1(rw,sync,no_subtree_check) hostname2(ro,sync,no_subtree_check)

#

Example for NFSv4:

/srv/nfs4        gss/krb5i(rw,sync,fsid=0,crossmnt,no_subtree_check)

/srv/nfs4/homes  gss/krb5i(rw,sync,no_subtree_check)

#
/var/www/cobbler/links/nexenta-a-x86_64 <em>(ro,sync,no_subtree_check)
/var/www/cobbler/links/&lt;nexenta-distribution-name&gt; </em>(ro,sync,no_subtree_check)
````
