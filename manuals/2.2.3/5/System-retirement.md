## Using DBAN with Cobbler to automate system retirement

### Introduction

The following method details using [DBAN](http://dban.sourceforge.net/) with Cobbler to create a PXE boot image that will securely wipe the disk of the system being retired. This could also be used if you are shipping a disk back to the manufacturer and wanted to ensure all data is "securely" wiped.

### Steps

#### DBAN 2.2.6

Retrieve the extra loader parts that DBAN 2.2.6 needs:

    cobbler get-loaders

Download DBAN:

    wget -O /tmp/dban-2.2.6_i586.iso http://prdownloads.sourceforge.net/dban/dban-2.2.6_i586.iso

Mount the ISO and copy the kernel image file and (optionally) the boot configuration file:

    mount -o loop,ro /tmp/dban-2.2.6_i586.iso /mnt
    mkdir -p /opt/cobbler/dban-2.2.6
    cp -p /mnt/dban.bzi /opt/cobbler/dban-2.2.6/
    cp -p /mnt/isolinux.cfg /opt/cobbler/dban-2.2.6/
    chmod -x /opt/cobbler/dban-2.2.6/*
    umount /mnt

Add the DBAN distro and profile to Cobbler.  Run sync to copy the loaders into place:

    cobbler distro add --name=DBAN-2.2.6-i586 --kernel=/opt/cobbler/dban-2.2.6/dban.bzi \
      --initrd=/opt/cobbler/dban-2.2.6/dban.bzi --kopts="nuke=dwipe silent"
    cobbler profile add --name=DBAN-2.2.6-i586 --distro=DBAN-2.2.6-i586
    cobbler sync

#### DBAN 1.0.7

Download DBAN:

    wget -O /tmp/dban-1.0.7_i386.iso http://prdownloads.sourceforge.net/dban/dban-1.0.7_i386.iso

Mount the ISO and copy the floppy disk image file:

    mount -o loop,ro /tmp/dban-1.0.7_i386.iso /mnt
    cp -p /mnt/dban_1_0_7_i386.ima /tmp/
    umount /mnt

Mount the floppy disk image file and copy the kernel image file, initial ram disk, and (optionally) the boot configuration file:

    mount -o loop,ro /tmp/dban_1_0_7_i386.ima /mnt
    mkdir -p /opt/cobbler/dban-1.0.7
    cp -p /mnt/initrd.gz /opt/cobbler/dban-1.0.7/
    cp -p /mnt/kernel.bzi /opt/cobbler/dban-1.0.7/
    cp -p /mnt/syslinux.cfg /opt/cobbler/dban-1.0.7/
    chmod -x /opt/cobbler/dban-1.0.7/*
    umount /mnt

Add the DBAN distro and profile to Cobbler:

    cobbler distro add --name=DBAN-1.0.7-i386 --kernel=/opt/cobbler/dban-1.0.7/kernel.bzi \
      --initrd=/opt/cobbler/dban-1.0.7/initrd.gz --kopts="root=/dev/ram0 init=/rc nuke=dwipe floppy=0,16,cmos"
    cobbler profile add --name=DBAN-1.0.7-i386 --distro=DBAN-1.0.7-i386

### Test

1. Add a system to be destroyed:

    cobbler system add --name=00:15:c5:c0:05:58 --profile=DBAN-1.0.7-i386

1. Sync cobbler:

    cobbler sync

1. Boot the system via PXE. The DBAN menu will pop up. Select the drives and hit F10 to start the wipe.

1. Remove the system from this profile so that you don't accidentally boot and wipe in the future:

    cobbler system remove --name=00:15:c5:c0:05:58

### Notes

You can setup DBAN to autowipe the system in question by supplying the kernel option of nuke="dwipe --autonuke". We are not doing it in this example because people sometimes only half-read things and it would suck to find out too late that you'd wiped a system you didn't mean to.

It should go without saying that, while it might be a mildly fun prank, you shouldn't set this to be your default pxe boot menu choice. You'll most likely get fired and/or beat up by your fellow employees.

If you do set this profile, it will show up as an option in the PXE menus. If this concerns you, set up a syslinux password by editing the templates in /etc/cobbler to ensure no one walks up to a system and blitzes it involuntarily. An option to keep a profile out of the PXE menu is doable if enough people request it or someone wants to submit a patch...

