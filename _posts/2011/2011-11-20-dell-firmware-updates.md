---
layout: post
title: Dell Firmware Updates
author: Michael DeHaan
summary: Semi-Automated firmware updates for Dell-machines.
---

Revised by: [itxx00](https://github.com/itxx00)

Dell firmware update images are based on Fedora's livecd-creator (part of the livecd-tools package), so you can download
the firmware update image, follow the instructions at [How To Boot Live CDs](How To Boot Live CDs) and use Cobbler to
deploy the image using PXE after converting it with livecd-iso-to-pxeboot (see instructions). This avoids having to
take media around to the various machines.

Here is an example of updating an entire network of machines. You may wish to be more or less fine grained:

    cobbler system add --name=updateme --ip=192.168.0.0/24 --profile=LIVE_UPDATE_MY_DELLS
    # cycle power on above systems, reboot, and then restore the default PXE booting behavior
    cobbler system remove --name=updateme

Adding to this because Dell has a set of repos designed to allow yum to inventory and update it's firmware:

    # Setting Up DSU Repository
    wget -q -O - http://linux.dell.com/repo/hardware/dsu/bootstrap.cgi| bash
    # Install firmware tools
    yum install dell-system-update
    # Inventorying Firmware
    dsu --inventory
    # Updating Firmware
    dsu
    # Reboot
    reboot

See here for the full set of instructions:
[http://linux.dell.com/repo/hardware/dsu/](http://linux.dell.com/repo/hardware/dsu/)

Or you can use dell linux repo as bellow, which is deprecated now.

    # set up repo
    wget -q -O - http://linux.dell.com/repo/hardware/latest/bootstrap.cgi | bash
    # install firmware tools
    yum install dell_ft_install
    # install BIOS update
    yum install $(bootstrap_firmware)
    # Inventory firmware version levels
    inventory_firmware
    # Compare versions installed to those available
    update_firmware
    # Install any applicable updates
    update_firmware --yes
    # Reboot to flash the new firmware
    reboot

See here for the full set of instructions:
[http://linux.dell.com/repo/hardware/latest/](http://linux.dell.com/repo/hardware/latest/)
