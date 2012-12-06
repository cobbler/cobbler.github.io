---
layout: manpage
title: Cobbler Manual
meta: 2.4.0
---
# Power PC support

Cobbler includes support for provisioning Linux on PowerPC systems.
This document will address how cobbler PowerPC support differs from
cobbler support for more common architectures, including i386 and
x86\_64.

## Setup

Support for network booting PowerPC systems is much like support
for network booting x86 systems using PXE. However, since PXE is
not available for PowerPC, [yaboot](http://yaboot.ozlabs.org) is
used to network boot your PowerPC systems. To start, you must
adjust the boot device order on your system so that a network
device is first. On x86-based architectures, this configuration
change would be accomplished by entering the BIOS. However,
[en.wikipedia.org/wiki/Open\_Firmware Open Firmware] is often used
in place of a BIOS on PowerPC platforms. Different PowerPC
platforms offer different methods for accessing Open Firmware. The
common procedures are outlined at
[http://en.wikipedia.org/wiki/Open\_Firmware\#Access](http://en.wikipedia.org/wiki/Open_Firmware#Access).
The following example demonstrates updating the boot device order.

Once at an Open Firmware prompt, to display current device aliases
use the `devalias` command. For example:

    0 > devalias 
    ibm,sp              /vdevice/IBM,sp@4000
    disk                /pci@800000020000002/pci@2,4/pci1069,b166@1/scsi@1/sd@5,0
    network             /pci@800000020000002/pci@2/ethernet@1
    net                 /pci@800000020000002/pci@2/ethernet@1
    network1            /pci@800000020000002/pci@2/ethernet@1,1
    scsi                /pci@800000020000002/pci@2,4/pci1069,b166@1/scsi@0
    nvram               /vdevice/nvram@4002
    rtc                 /vdevice/rtc@4001
    screen              /vdevice/vty@30000000
     ok

To display the current boot device order, use the `printenv`
command. For example:

    0 > printenv boot-device 
    -------------- Partition: common -------- Signature: 0x70 ---------------
    boot-device              /pci@800000020000002/pci@2,3/ide@1/disk@0 /pci@800000020000002/pci@2,4/pci1069,b166@1/scsi@1/sd@5,0 
     ok

To add the device with alias **network** as the first boot device,
use the `setenv` command. For example:

    0 > setenv boot-device network /pci@800000020000002/pci@2,3/ide@1/disk@0 /pci@800000020000002/pci@2,4/pci1069,b166@1/scsi@1/sd@5,0

Your system is now configured to boot off of the device with alias
**network** as the first boot device. Should booting off this
device fail, your system will fallback to the next device listed in
the **boot-device** Open Firmware settings.

## System-based configuration

To begin, you need to first configure a Cobbler server. Cobbler can
be run on any Linux system accessible by the your PowerPC system,
including an x86 system, or another PowerPC system. This server's
primary responsibility is to host the Linux install tree(s)
remotely, and maintain information about clients accessing it. For
detailed instructions on configuring the Cobbler server, see:

[https://fedorahosted.org/cobbler/UserDocumentation](https://fedorahosted.org/cobbler/UserDocumentation)

Next, it's time to add a system to cobbler. The following command
will add a system named *ibm-505-lp1* to cobbler. Note that the
cobbler profile specified (*F-11-GOLD-ppc64*) must already exist.

    cobbler system add --name ibm-505-lp1 --hostname ibm-505-lp1.example.com \
      --profile F-11-GOLD-ppc64 --kopts "console=hvc0 serial" \
      --interface 0 --mac 00:11:25:7e:28:64

Most of the options to cobbler system add are self explanatory
network parameters. They are fully explained in the cobbler man
page (see man cobbler). The --kopts option is used to specify any
system-specific kernel options required for this system. These will
vary depending on the nature of the system and connectivity. In the
example above, I chose to redirect console output to a device
called *hvc0* which is a specific console device available in some
virtualized guest environments (including KVM and PowerPC virtual
guests).

In the example above, only one MAC address was specified. If
network booting from additional devices is desired, you may wish to
add more MAC addresses to your system configuration in cobbler. The
following commands demonstrate adding additional MAC addresses:

    cobbler system edit --name ibm-505-lp1 --interface 1 --mac 00:11:25:7e:28:65
    cobbler system edit --name ibm-505-lp1 --interface 2 --mac 00:0d:60:b9:6b:c8

Note: Providing a MAC address is required for proper network boot
support using yaboot.

## Profile-based configuration

Profile-based network installations using yaboot are not available
at this time. OpenFirmware is only able to load a bootloader into
memory once. Once, yaboot is loaded into memory from a network
location, you are not able to exit and load an on-disk yaboot.
Additionally, yaboot requires specific device locations in order to
properly boot. At this time there is no *local* boot target as
there are in PXE configuration files.

## Troubleshooting

### OpenFirmware Ping test

If available, some PowerPC systems offer a management interface
available from the boot menu or accessible from OpenFirmware
directly. On IBM PowerPC systems, this interface is called SMS.

To enter SMS while your IBM PowerPC system is booting, press *1*
when prompted during boot up. A sample boot screen is shown below:

    IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
    IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
    IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
    IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
    
              1 = SMS Menu                          5 = Default Boot List
              8 = Open Firmware Prompt              6 = Stored Boot List
    
    
         Memory      Keyboard     Network     SCSI    

To enter SMS from an OpenFirmware prompt, type:

    dev /packages/gui obe

Once you've entered the SMS, you should see an option menu similar
to:

     SMS 1.6 (c) Copyright IBM Corp. 2000,2005 All rights reserved.
    -------------------------------------------------------------------------------
     Main Menu
     1.   Select Language
     2.   Setup Remote IPL (Initial Program Load)
     3.   Change SCSI Settings
     4.   Select Console
     5.   Select Boot Options

To perform the ping test:

1.  Select `Setup Remote IPL`
2.  Select the appropriate network device to use
        -------------------------------------------------------------------------------
         NIC Adapters
              Device                          Location Code                 Hardware
                                                                            Address
         1.  Port 1 - IBM 2 PORT 10/100/100  U789F.001.AAA0060-P1-T1  0011257e2864
         2.  Port 2 - IBM 2 PORT 10/100/100  U789F.001.AAA0060-P1-T2  0011257e2865

3.  Select `IP Parameters`
        -------------------------------------------------------------------------------
         Network Parameters
        Port 1 - IBM 2 PORT 10/100/1000 Base-TX PCI-X Adapter: U789F.001.AAA0060-P1-T1
         1.   IP Parameters
         2.   Adapter Configuration
         3.   Ping Test
         4.   Advanced Setup: BOOTP

4.  Enter your local network settings
        -------------------------------------------------------------------------------
         IP Parameters
        Port 1 - IBM 2 PORT 10/100/1000 Base-TX PCI-X Adapter: U789F.001.AAA0060-P1-T1
         1.   Client IP Address                    [0.0.0.0]
         2.   Server IP Address                    [0.0.0.0]
         3.   Gateway IP Address                   [0.0.0.0]
         4.   Subnet Mask                          [0.0.0.0]

5.  When complete, press `Esc`, and select `Ping Test`

The results of this test will confirm whether your network settings
are functioning properly.

### Confirm Cobbler Settings

Is your system configured to netboot? Confirm this by using the
following command:

    # cobbler system report --name ibm-505-lp1 | grep netboot 
    netboot enabled?      : True

### Confirm Cobbler Configuration Files

Cobbler stores network boot information for each MAC address
associated with a system. When a PowerPC system is configured for
netbooting, a cobbler will create the following two files inside
the tftp root directory:

-   ppc/01-<MAC\_ADDRESS\> - symlink to the ../yaboot
-   etc/01-<MAC\_ADDRESS\> - a yaboot.conf configuration

Confirm that the expected boot and configuration files exist for
each MAC address. A sample configuration is noted below:

    # for MAC in $(cobbler system report --name ibm-505-lp1 | grep mac | gawk '{print $4}' | tr ':' '-');
    do
        ls /var/lib/tftpboot/{ppc,etc}/01-$MAC ;
    done
    /var/lib/tftpboot/etc/01-00-11-25-7e-28-64
    /var/lib/tftpboot/ppc/01-00-11-25-7e-28-64
    /var/lib/tftpboot/etc/01-00-11-25-7e-28-65
    /var/lib/tftpboot/ppc/01-00-11-25-7e-28-65
    /var/lib/tftpboot/etc/01-00-0d-60-b9-6b-c8
    /var/lib/tftpboot/ppc/01-00-0d-60-b9-6b-c8

### Confirm Permissions

Be sure that SELinux file context's and file permissions are
correct. SELinux file context information can be reset according to
your system policy by issuing the following command:

    # restorecon -R -v /var/lib/tftpboot 

To identify any additional permissions issues, monitor the system
log file `/var/log/messages` and the SELinux audit log
`/var/log/audit/audit.log` while attempting to netboot your
system.

### Latest yaboot?

Network boot support requires a fairly recent yaboot. The yaboot
included in cobbler-1.4.x may not support booting recent Fedora
derived distributions. Before reporting a bug, try updating to the
latest yaboot binary. The latest yaboot binary is available from
Fedora rawhide at
[http://download.fedoraproject.org/pub/fedora/linux/development/ppc/os/ppc/chrp/yaboot](http://download.fedoraproject.org/pub/fedora/linux/development/ppc/os/ppc/chrp/yaboot).

## References

* Additional OpenFirmware information available at
[http://oss.gonicus.de/openpower/index.php/OpenFirmware](http://oss.gonicus.de/openpower/index.php/OpenFirmware)

