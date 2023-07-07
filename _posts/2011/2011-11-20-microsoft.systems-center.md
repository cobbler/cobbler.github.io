---
layout: post
title: Microsoft Systems Center
author: Michael DeHaan
summary: Microsoft Systems Center
---

## Creating a PXE boot menu item for integration with SCCM

This article assumes you are working with a Systems Center Configuration Manager deployment along with Cobbler. This
will allow you to boot to a SCCM install via the Cobbler PXE menu.

## Create a SCCM boot CD and modify contents

In SSCM create a CD boot media and extract the contents to a temp dir, we'll be using `d:\\sccm\_boot\\` in this
example. Then use imagex to mount the wim file

    imagex /mountrw d:\sccm_boot\Sources\boot.wim 1 d:\wim_mount

Then copy over the SMS data directory to the mounted WIM file, grab the files needed for PXE boot, and then umount the WIM

    xcopy /s /i D:\sccm_boot\sms\data\* d:\wim_mount\sms\data
    copy d:\wim_mount\windows\boot\pxe\bootmgr.exe d:\sccm_boot
    copy d:\wim_mount\windows\boot\pxe\pxeboot.n12 d:\sccm_boot
    imagex /unmount /commit D:\wim_mount 

## Cobbler Server Setup

Copy the files to the Cobbler server, in this example we'll use pscp

    pscp d:\sccm_boot\Sources\boot.wim cobbler_server:/tftpboot/sources
    pscp d:\sscm_boot\bootmgr.exe cobbler_server:/tftpboot/boot
    pscp d:\sscm_boot\pxeboot.n12 cobbler_server:/tftpboot/boot
    pscp d:\sscm_boot\boot\bcd cobbler_server:/tftpboot/boot
    pscp d:\sscm_boot\boot\boot.sdi cobbler_server:/tftpboot/boot

Make symlinks on the Cobbler server

    ln -s /tftpboot/boot /tftpboot/Boot
    ln -s /tftpboot/boot/BCD /tftpboot/boot/bcd
    ln -s /tftpboot/boot/pxeboot.n12 /tftpboot/boot/pxeboot.0
    ln -s /tftpboot/boot/bootmgr.exe /tftpboot/bootmgr.exe

Create the file /etc/default/tftpd.rules with the following:

    rg \\ / # Convert backslashes to slashes

Modify `/etc/xinetd.d/tftp` and change the `server_args` line to look like the following. Note that the `-v` doesn't
have to be there, as it puts tftpd in verbose mode. This is useful for troubleshooting your first couple of SCCM boots
as it may be missing files.

    server_args             = -s /tftpboot -m /etc/default/tftpd.rules -v

Restart xinetd

    service xinetd restart

Now, because Cobbler requires a "initd" flag when adding a new distro, I had to modify the
`/etc/cobbler/pxe/pxedefault.template` with the following. You can add it anywhere, I added it after the
`$pxe_menu_items` so it will always be at the bottom.

    LABEL sccm
            kernel /Boot/pxeboot.0
            MENU LABEL M$ System Center Configuration Manager

That should be it, you should now be able to PXE boot, select the SCCM item, and begin building your win32 based system.

## References

Using WDS to deploy SCCM images without the SCCM PSP Integration
[http://www.deployvista.com/Blog/tabid/70/EntryID/54/language/sv-SE/Default.aspx](http://www.deployvista.com/Blog/tabid/70/EntryID/54/language/sv-SE/Default.aspx)

Boot WinPE 2.0 from Linux PXE Server
[http://wiki.snet.at/doku.php/boot\_winpe\_2.0\_from\_linux\_pxe\_server](http://wiki.snet.at/doku.php/boot_winpe_2.0_from_linux_pxe_server)

