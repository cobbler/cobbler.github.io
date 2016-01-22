---
layout: manpage
title: Booting Live CD's
meta: 2.8.0
---

Live CD's can be used for a variety of tasks.  They might update firmware, run diagnostics, assist with cloning systems, or just serve up a desktop environment.

### With Cobbler

Somewhat unintuitively, LiveCD's are booted by transforming the CD ISO's to kernel+initrd files.

Take the livecd and install livecd-tools.  You may need a recent Fedora (F9+) to find livecd-tools.  What we are about to do is convert the live image to something that is PXEable.  It will produce a kernel image and a VERY large initrd which essnetially contains the entire ISO.  Once this is done it is PXE-bootable, but we still have to provide the right kernel arguments.

    livecd-iso-to-pxeboot live-image.iso


This will produce a subdirectory in the current directory called ./tftpboot.  You need to save the initrd and the vmlinuz from this directory, and as a warning, the initrd is as big as the live image.  Make sure you have space.



    mkdir -p /srv/livecd
    cp /path/to/cwd/tftpboot/vmlinuz0 /srv/livecd/vmlinuz0
    cp /path/to/cwd/tftpboot/initrd.img /srv/livecd/initrd.img

    cobbler distro add --name=liveF9 --kernel=/srv/livecd/vmlinuz0 --initrd=/srv/livecd/initrd.img


Now we must add some parameters to the kernel and create a dummy profile object.  Note we are passing in some extra kernel options and telling cobbler it doesn't need many of the default ones because it can save space.  Be sure the "/name-goes-here.iso" part of the path matches up with the ISO you ran livecd-iso-to-pxeboot against exactly or the booting will not be successful.

    cobbler distro edit --name=liveF9 --kopts='root=/f9live.iso rootfstype=iso9660 rootflags=loop !text !lang !ksdevice'
    cobbler profile add --name=liveF9 --distro=liveF9

At this point it will work as though it is a normal "profile", though it will boot the live image as opposed to an installer image.

For instance, if we wanted to deploy the live image to all machines on a specific subnet we could do it as follows:

    cobbler system add --name=live_network --ip-address=123.45.00.00/24 --profile=liveF9

Or of course we could just deploy it to a specific system:

    cobbler system add --name=xyz --mac=AA:BB:CC:DD:EE:FF --profile=liveF9

And of course this will show up in the PXE menus automatically as well.

### Notes

When you boot this profile it will take a relatively long time (3-5 minutes?) and you will see a lot of dots printed on the screen.  This is expected behavior as it has to transfer a large amount of data.

### Space Considerations

The Live Images are very large.  Cobbler will try to hardlink them if the vmlinuz/initrd files are on the same device, but it cannot symlink because of the way TFTP (needed for PXE) requires a chroot environment.  If your distro add command takes a long time, this is because of the copy, please make sure you have the extra space in your TFTP boot directory's partition (either `/var/lib/tftpboot` or `/tftpboot` depending on OS).

### Troubleshooting

If you boot into the live environment and it does not work right, most likely the rootflags and other parameters are incorrect.   Recheck them with "cobbler distro report --name=foo"
