---
layout: manpage
title: Distribution Support
meta: 2.2.3
---
# {{ page.title }}

Cobbler was originally written to support Fedora, Red Hat, and derivative distributions such as CentOS or Scientific Linux. Cobbler now works for managing other environments, including mixed environments, occasionally with some limitations. Debian and SuSE support is quite strong, with patches coming in from developers working on those distributions as well.  

## Debian and Ubuntu

Most Debian and Ubuntu versions should be correctly recognized when using the "cobbler import" command. 

There is currently no support for using the --available-as option with import, unless you're pointing at a web location that does not house multiple versions of the distro.

Support for Ubuntu has increased dramatically in the 2.2.x releases, however there is still some work to be done - particularly around automation and snippet support. The preseed format also allows for only a single script to be run for pre and post installation actions, so right now the only option is to manually configure something like the following:

{% highlight bash %}
wget -O- http://server/path/to/post-install-script | bash -s
{% endhighlight %}

In the future, we will be looking to add native support for that in cobbler for the preseed format.

APT repositories can be managed from RPM based systems, as long as you install the debmirror package for your distribution.

### Notes About Debian

The Debian distribution does not currently have a focus on network-based automated installs. As such, there are a few extra steps that must be taken to convert a normal DVD distribution to one that can be installed via PXE. Instructions for doing this are currently out of the scope of this manual, however a quick Google search should turn up what you steps you need to take to make this happen.

## SuSE

Most SuSE versions should be correctly recognized when using the "cobbler import" command.

When used, the "--kickstart" argument for "cobbler profile add" references a AutoYaST XML file, not an actual kickstart, though the templating works the same.

SuSE repos can be managed with yum, so that works as with the Red Hat based distributions.

Unlike Red Hat, SuSE (SLES) keeps its bootup files in a much different directory. For SLES 10, they are located here where "arch" is i386 or x86\_64:

1. /boot/arch/loader/linux (kernel file)
2. /boot/arch/loader/initrd (initrd file)

I would recommend that you put your sles distro folder (suse10x86sp2) in /var/www/ks\_mirror where all the others are kept. Then change your path in the command below:

{% highlight bash %}
$ cobbler distro add --arch=x86 --breed=suse --initrd=/var/www/ks_mirror/suse10x86sp2/boot/i386/loader/initrd --kernel=/var/www/ks_mirror/suse10x86sp2/boot/i386/loader/linux --name=SLES10-x86-sp2 --os-version=sles10
{% endhighlight %}

You will also want to append the following kernel arg with --kopts:

{% highlight bash %}
install=http://IP/cobbler/ks_mirror/sles9-i386
{% endhighlight %}

## VMWare ESX/ESXi

Older versions of ESX and ESXi (before version 5) should work fine with not much extra work. ESX3/4 essentially used a variant of RHEL as the Dom0, so installation follows the regular RHEL/CentOS methods. ESXi4 was slightly different, but should work out of the box as well.

ESXi5 now has BETA support, but requires the use of gPXE, which is new in Cobbler 2.2.3. The build process for this has receieved limited support beyond verifying that cobbler will import the distro and configure things somewhat automatically. Be sure to install the correct gPXE packages for your distribution.

## FreeBSD

The following steps are required to enable FreeBSD support in Cobbler.

You can grab the patches and scripts from the following github repos:

[git://github.com/jsabo/cobbler\_misc.git](git://github.com/jsabo/cobbler_misc.git)

This would not be possible without the help from Doug Kilpatrick. Thanks Doug!

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

## Where the Cobbler Server Can Be Installed

Cobbler runs happiest on Red Hat Enterprise Linux, Fedora, or RHEL clone like CentOS. We are continuing to work on supporting running cobbler on other distributions, however this support should be considered BETA for the time being.

Please refer to the {% linkup title:"Installing Cobbler" extrameta:2.2.3 %} section for details regarding the installation on various platforms.

## Reinstallation, Virtualization, and Koan in general

Koan works fine on Fedora, Red Hat Enterprise Linux, or CentOS.  It is intended to work on other (Linux) platforms as well, when it does not, please file a bug report or send us a patch!
