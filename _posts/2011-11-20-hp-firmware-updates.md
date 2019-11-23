---
layout: post
title: HP Firmware Updates
author: Michael DeHaan
summary: Semi-Automated firmware updates for HP-machines.
---

Thanks @ [Bob Mader](https://github.com/swapdisk) for updating the dead link! (2015-10-26)

Not only is it possible to use HP's Firmware Update ISO through PXE, but it can also be managed by Cobbler.

I give much credit to this
[thread](http://h30499.www3.hp.com/t5/ITRC-ProLiant-Deployment/PXE-Boot-Image-from-an-ISO/td-p/3743865/page/10)
on HP's forums for helping me with figuring out this process.

We'll need to start a NFS server and open the appropriate ports on the firewall. Edit your /etc/exports file and add an
entry for where you will dump your firmware ISOs. I just open up the entire cobbler build tree via NFS, just to make
things easier:

    /data/linux_build        *(ro,insecure,all_squash,no_subtree_check,nohide)

For firewall access, use system-config-security level and enable NFS4 or add the following to /etc/sysconfig/iptables :

    -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 2049 -j ACCEPT

Be sure to restart iptables:

    service iptables restart

We'll be storing the HP firmware ISOs in `/data/linux_build/firmware/`.

Since the latest available HP Firmware Update CD is 9.30, we'll
[download](ftp://ftp.hp.com/pub/softlib2/software1/cd/p1040529012/v64851/firmware-9.30-0.zip) that and put it in
`/data/linux_build/firmware/fw930`.

Unzip the iso, and rename it to something cleaner like fw930.iso.

loopback mount the iso, and copy the initrd.img and vmlinuz from the iso and put them in
`/data/linux_build/firmware/fw930`.

    mount -o loop /data/linux_build/firmware/fw930/fw930.iso /mnt/
    cp /mnt/system/vmlinuz  /data/linux_build/firmware/fw930/
    cp /mnt/system/initrd.img  /data/linux_build/firmware/fw930/

Now we add the HP Firmware Update ISO as a "distro" and add the profile as well:

Make sure your substitute yourserver.lab.yourcompany.com with the server your NFS hostname!

    cobbler distro add --name=hp_firmware_update_v9.30 --arch=x86 --breed=debian \
    --kernel=/data/linux_build/firmware/fw930/vmlinuz --initrd=/data/linux_build/firmware/fw930/initrd.img \
    --kopts 'rw PROTOCOL=DHCP ip=dhcp root=/dev/ram0 iso1=nfs://yourserver.lab.yourcompany.com/data/linux_build/firmware/fw930/fw930.iso init=/bin/init media=cdrom ramdisk_size=127464 ide=noraid pnpbios=off'
    cobbler profile add --name=hp_firmware_update_v9.30 --distro=hp_firmware_update_v9.30
    cobbler sync

You may get the following warning during cobbler sync, but it hasn't proved an issue for me.

    warning: kernel option length exceeds 255

On the aforementioned thread, you will also find information on automating the firmware install process so it can be
done hands-free. You could also add supplemental updates to the ISO as well.
