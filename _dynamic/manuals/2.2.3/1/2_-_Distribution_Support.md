---
layout: manpage
title: Cobbler Manual - Distribution Support
meta: 2.2.3
---
# Distribution Support

Cobbler was originally written to support Fedora, Red Hat, and
derivative distributions such as CentOS or Scientific Linux.
Cobbler now works for managing other environments,
including mixed environments, occasionally with some limitations. 
Debian and SuSE support is quite strong, with patches coming
in from developers working on those distributions as well.  

## Debian and Ubuntu

"cobbler distro add" works if you use --breed=debian.

This will treat any kickstart files as preseeds. Be sure to use the
appropriate contents for preseed templates and add on any
additional kernel arguments you may need.

## SuSE

"cobbler distro add" works if you use "--breed=suse". This will
make cobbler use the right kernel options so you can PXE these
OS's. When used, the "--kickstart" argument for "cobbler profile
add" references a AutoYaST XML file, not an actual kickstart,
though the templating works the same.

SuSE repos can be managed with yum, so that works as with the Red
Hat based distributions.

Unlike Red Hat, SuSE (SLES) keeps its bootup
files in a much different directory. For SLES 10, they are located
here where "arch" is i386 or x86\_64:

1.  /boot/arch/loader/linux (kernel file)
2.  /boot/arch/loader/initrd (initrd file)

I would recommend that you put your sles distro folder
(suse10x86sp2) in /var/www/ks\_mirror where all the others are
kept. Then change your path in the command below

    cobbler distro add --arch=x86 --breed=suse --initrd=/var/www/ks_mirror/suse10x86sp2/boot/i386/loader/initrd --kernel=/var/www/ks_mirror/suse10x86sp2/boot/i386/loader/linux --name=SLES10-x86-sp2 --os-version=sles10

You will also want to append the following kernel arg with
--kopts:

    install=http://IP/cobbler/ks_mirror/sles9-i386

### SLES9 Support

SLES9 needs special attention because of the way the CDs are packaged. Following this method it should work for your environment:

    * Create directory and copy SLES9 and SLES9 SP4 CD's as following:
     # Make directories in installation dir
         
     - mkdir -p SLES9/CD1
     - mkdir -p CORE9/CD1
     - mkdir -p CORE9/CD2
     - mkdir -p CORE9/CD3
     - mkdir -p SLES9_SP4/CD1
     - mkdir -p SLES9_SP4/CD2
         
     # copy media using rsync
     # example: rsync -avz --progress /mnt/iso1/ /var/www/cobbler/ks_mirror/SLES9-x86/SLES9/CD1/
        
     - SLES-9-i386-RC5-CD1.iso - SLES9/CD1  
     - SLES-9-i386-RC5-CD2.iso - CORE9/CD1
     - SLES-9-i386-RC5-CD3.iso - CORE9/CD2
     - SLES-9-i386-RC5-CD4.iso - CORE9/CD3
     - SLES-9-i386-RC5-CD5.iso - CORE9/CD4  (src cd, not needed)
     - SLES-9-i386-RC5-CD6.iso - CORE9/CD5  (src cd, not needed)
     - SLES-9-SP4-CD-i386-GM-CD1.iso - SLES9_SP4/CD1
     - SLES-9-SP4-CD-i386-GM-CD1.iso - SLES9_SP4/CD2
     - SLES-9-SP4-CD-i386-GM-CD1.iso - SLES9_SP4/CD3 (src cd, not needed)
        
     * Make links to the root of installation directory:
     - ln -s SLES9/CD1/content content
     - ln -s SLES9/CD1/control.xml control.xml
     - ln -s SLES9/CD1/media.1 media.1
     - ln -s SLES9_SP4/CD1/driverupdate driverupdate
     - ln -s SLES9_SP4/CD1/linux linux
     - ln -s SLES9/CD1/boot boot
        
     * Copy the updated kernel/initrd from SP4 directory (if you don't do this network cards will not be detected)
     - cp SLES9_SP4/CD1/boot/linux boot/
     - cp SLES9_SP4/CD1/boot/initrd boot/
        
     * Create directory "yast" and the following files into it:
     Those are tabs between entries
     - create instorder file:
        
     /SLES9_SP4/CD1                      
     /SLES9/CD1                      
     /CORE9/CD1
        
    - create order file:
    
    /SLES9_SP4/CD1  /SLES9_SP4/CD1
    /SLES9/CD1      /SLES9/CD1
    /CORE9/CD1      /CORE9/CD1

So this basically looks like:

    dr-xr-xr-x 3  501 games 4096 Mar  9 17:01 boot  
    lrwxrwxrwx 1  501 games   17 Mar 10 14:39 content -> suse9/CD1/content  
    lrwxrwxrwx 1  501 games   21 Mar 10 14:39 control.xml -> suse9/CD1/control.xml  
    drwxr-xr-x 6  501 games 4096 Mar  9 16:28 core9  
    lrwxrwxrwx 1  501 games   25 Mar 10 14:41 driverupdate -> suse9sp4/CD1/driverupdate  
    lrwxrwxrwx 1  501 games   18 Mar 10 14:41 linux -> suse9sp4/CD1/linux  
    lrwxrwxrwx 1  501 games   18 Mar 10 14:41 media.1 -> suse9/CD1/media.1/  
    drwxr-xr-x 3  501 games 4096 Mar  9 16:28 suse9  
    drwxr-xr-x 4  501 games 4096 Mar  9 16:33 suse9sp4  
    drwxr-xr-x 2 root root  4096 Mar 10 16:59 yast  
    [root@cobbler SLES9-i386-SP4]# ls yast  
    instorder  order  

## VMWare ESX/ESXi

Older versions of ESX and ESXi (before version 5) should work fine with not much extra work. ESX3/4 essentially used a variant of RHEL as the Dom0, so installation follows the regular RHEL/CentOS methods. ESXi4 was slightly different, but should work out of the box as well.

ESXi5 now has BETA support, but requires the use of gPXE, which is new in Cobbler 2.2.3. The build process for this has receieved limited support beyond verifying that cobbler will import the distro and configure things somewhat automatically. Be sure to install the correct gPXE packages for your distribution.

## FreeBSD

The following steps are required to enable FreeBSD support in
Cobbler.

You can grab the patches and scripts from the following github
repos:

\*
[git://github.com/jsabo/cobbler\_misc.git](git://github.com/jsabo/cobbler_misc.git)

This would not be possible without the help from Doug Kilpatrick.
Thanks Doug!

### Stuff to do once

\* Install FreeBSD with full sources

-   Select "Standard" installation
-   Use entire disk
-   Install a standard MBR
-   Create a new slice and use the entire disk
-   Mount it at /
-   Choose the "Developer" distribution
    -   Full sources, binaries and doc but no games

-   Install from a FreeBSD CD/DVD
-   Setup networking to copy files back and forth
-   In the post install "Package Selection" scroll down and select
    shells
    -   Install bash
    -   chsh -s /usr/local/bin/bash username or vipw


\* Rebuild pxeboot with tftp support

      (cd /sys/boot; make clean; make LOADER_TFTP_SUPPORT=yes; make install)

Copy the pxeboot to the Cobbler server.

### Stuff to do every supported release

\* Patch sysinstall with http install support

-   The media location is hard coded in this patch and has to be
    updated every release. Just look for 8.X and change it.

The standard sysinstall doesn't really support HTTP. This patch
adds full http support to sysinstall.

      (cd /usr; patch -p0 < /root/http_install.patch)

\* Rebuild FreeBSD mfsroot

We'll use "crunchgen" to create the contents of /stand in a ramdisk
image. Crunchgen creates a single statically linked binary that
acts like different normal binaries depending on how it's called.
We need to include "fetch" and a few other binaries. This is a
multi step process.

      (mkdir /tmp/bootcrunch; cd /tmp/bootcrunch; crunchgen -o /root/boot_crunch.conf; make -f boot_crunch.mk)

Once we've added our additional binaries we need to create a larger
ramdisk.

Create a new, larger ramdisk, and mount it.

      dd if=/dev/zero of=/tmp/mfsroot bs=1024 count=$((1024 * 5))
      dev0=`mdconfig -f /tmp/mfsroot`;newfs $dev0;mkdir /mnt/mfsroot_new;mount /dev/$dev0 /mnt/mfsroot_new

Mount the standard installer's mfsroot

      mkdir /mnt/cdrom; mount -t cd9660 -o -e /dev/acd0 /mnt/cdrom
      cp /mnt/cdrom/boot/mfsroot.gz /tmp/mfsroot.old.gz
      gzip -d /tmp/mfsroot.old.gz; dev1=`mdconfig -f /tmp/mfsroot.old`
      mkdir /mnt/mfsroot_old; mount /dev/$dev1 /mnt/mfsroot_old

Copy everything from the old one to the new one. You'll be
replacing the binaries, but it's simpler to just copy it all over.

      (cd /mnt/mfsroot_old/; tar -cf - .) | (cd /mnt/mfsroot_new; tar -xf -)

Next copy over the new bootcrunch file and create all of the
symlinks after removing the old binaries.

      cd /mnt/mfsroot_new/stand; rm -- *; cp /tmp/bootcrunch/boot_crunch ./
      for i in $(./boot_crunch 2>&1|grep -v usage);do if [ "$i" != "boot_crunch" ];then rm -f ./"$i";ln ./boot_crunch "$i";fi;done

Sysinstall uses install.cfg to start the install off. We've created
a version of the install.cfg that uses fetch to pull down another
configuration file from the Cobbler server which allows us to
dynamically control the install. install.cfg uses a script called
"doconfig.sh" to determine where the Cobbler installer is via the
DHCP next-server field.

Copy both install.cfg and doconfig.sh into place.

      cp {install.cfg,doconfig.sh} /mnt/mfsroot_new/stand

Now just unmount the ramdisk and compress the file

      umount /mnt/mfsroot_new; umount /mnt/mfsroot_old
      mdconfig -d -u $dev0; mdconfig -d -u $dev1
      gzip /tmp/mfsroot

Copy the mfsroot.gz to the Cobbler server.

### Stuff to do in Cobbler

\* Enable Cobbler's tftp server in modules.conf

    [tftpd]
    module = manage_tftpd_py

\* Mount the media

      mount /dev/cdrom /mnt

\* Import the distro

      cobbler import --path=/mnt/ --name=freebsd-8.2-x86_64

\* Copy the mfsroot.gz and the pxeboot.bs into the distro

      cp pxeboot.bs /var/www/cobbler/ks_mirror/freebsd-8.2-x86_64/boot/
      cp mfsroot.gz /var/www/cobbler/ks_mirror/freebsd-8.2-x86_64/boot/

\* Configure a system to use the profile, turn on netboot, and off
you go.

DHCP will tell the system to request pxelinux.0, so it will.
Pxelinux will request it's configuration file, which will have
pxeboot.bs as the "kernel". Pxelinux will request pxeboot.bs, use
the extention (.bs) to realize it's another boot loader, and chain
to it. Pxeboot will then request all the .rc, .4th, the kernel, and
mfsroot.gz. It will mount the ramdisk and start the installer. The
installer will connect back to the Cobbler server to fetch the
install.cfg (the kickstart file), and do the install as instructed,
rebooting at the end.

## Where the Cobbler server can be installed

Folks have reported getting cobbler to install and be happy running on a Debian server, though this is not officially supported.  Cobbler runs happiest on Red Hat Enterprise Linux, Fedora, or CentOS. We are continuing to work on supporting running cobbler on other distributions, however this support should be considered BETA for the time being.

## Reinstallation, Virtualization, and Koan in general

Koan works fine on Fedora, Red Hat Enterprise Linux, or CentOS.  It is intended to work on other (Linux) platforms as well, when it does not, please file a bug report or send us a patch!
