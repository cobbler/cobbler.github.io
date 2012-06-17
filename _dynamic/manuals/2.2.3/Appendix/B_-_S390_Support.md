---
layout: manpage
title: Cobbler Manual
meta: 2.2.3
---
### Introduction

Cobbler includes support for provisioning Linux on virtualized guests under z/VM, the System z hypervisor. 

### Quickstart Guide

To begin, you need to first configure a Cobbler server.  Cobbler can be run on any Linux system accessible by the mainframe, including an x86 system or another System z guest.  This server's primary responsibility is to host the Linux install tree(s) remotely, and maintain information about clients accessing it.  For detailed instructions on configuring the Cobbler server, see:

     https://fedorahosted.org/cobbler/UserDocumentation

We will assume static networking is used for System z guests.

After the Cobbler server is running, and you have imported at least one s390x install tree, you can customize the default kickstart template.  Cobbler provides a sample kickstart template that you can start with called /var/lib/cobbler/kickstarts/sample.ks.  You will want to copy this sample, and modify it by adding the following snippet in %post:

    $SNIPPET('post_s390_reboot')

Next, it's time to add a system to Cobbler.  Unlike traditional PXE, where unknown clients are identified by MAC address, zPXE uses the z/VM user ID to distinguish systems.  For example, to add a system with z/VM user ID ''z01'':


    cobbler system add --name z01 \
    --hostname=z01.example.com --ip=10.10.10.100 --subnet=10.10.10.255 --netmask=255.255.255.0 \
    --name-servers=10.10.10.1 --name-servers-search=example.com:example2.com \
    --gateway=10.10.10.254 --kopts="LAYER2=0 NETTYPE=qeth PORTNO=0 cms=None \
    HOSTNAME=z01.example.com IPADDR=10.10.10.100 SUBCHANNELS=0.0.0600,0.0.0601,0.0.0602 \
    MTU=1500 BROADCAST=10.10.10.255 SEARCHDNS=example.com:example2.com \
    NETMASK=255.255.255.0 DNS=10.10.10.1 PORTNAME=UNASSIGNED \
    DASD=100-101,200 GATEWAY=10.10.10.254 NETWORK=10.10.10.0"


Most of the options to ''cobbler system add'' are self explanatory network parameters.  They are fully explained in the cobbler man page (see ''man cobbler'').  The --kopts option is used to specify System z specific kernel options needed by the installer.  These are the same parameters found in the PARM or CONF file of a traditional installation, and in fact will be placed into a PARM file used by zPXE.  For any parameters not specified with --kopts, the installer will prompt you during kickstart in the 3270 console.  For a truly non-interactive installation, make sure to specify at least the parameters listed above.

Now that you've added a system to Cobbler, it's time to configure zPXE, the Cobbler-specific System z PXE emulator client, which ships with Cobbler.  zPXE is designed to replace PROFILE EXEC for a System z guest.  Alternatively, you can simply call ZPXE EXEC from your existing PROFILE EXEC.  The following example assumes the z/VM FTP server is running; however, you can also FTP from z/VM to the cobbler server.  Transfer zpxe.rexx to z/VM:


    # cd /var/lib/cobbler
    # ftp zvm.example.com
    ==> ascii
    ==> put zpxe.rexx zpxe.exec
    ==> bye


Next, logon to z/VM, and backup the current PROFILE EXEC and rename ZPXE EXEC:


    ==> rename profile exec a = execback =
    ==> rename zpxe exec a profile = =


Finally, you need to create a ZPXE CONF to specify the cobbler server hostname, as well as the default disk to IPL.  Use xedit to create this file.  It has only two lines. 


    ==> xedit zpxe conf a

    00000 * * * Top of File * * *
    00001 HOST example.server.com
    00002 IPLDISK 100
    00003 * * * End of File * * *

zPXE is now configured.  The client will attempt to contact the server at each logon.  If there is a system record available, and it is set to be reinstalled, zPXE will download the necessary files and begin the kickstart.

To schedule an install, run the following command on the cobbler server:

    cobbler system edit --name z01 --netboot-enabled 1 --profile RHEL-5-Server-U1-s390x


### Internals: How It Works

Now let's take a look at how zPXE works.  First, it defines a 50 MB VDISK, which is large enough to hold a kernel and initial RAMdisk, and enough free space to convert both files to 80-character width fixed record length.  Since VDISK is used, zPXE does not require any writeable space on the user's 191(A) disk.  This makes it possible to use zPXE as a read-only PROFILE EXEC shared among many users.

Next, the client uses the z/VM TFTP client to contact the server specified in ZPXE CONF.  It attempts to retrieve, in the following order:

 1. {{{/s390x/s_systemname}}}, if found, the following files will be downloaded:
    * {{{/s390x/s_systemname_parm}}}
    * {{{/s390x/s_systemname_conf}}}
 1. {{{/s390x/profile_list}}}

When netboot is enabled on the cobbler server, it places a file called s_''systemname'' (where ''systemname'' = z/VM user ID) into /var/lib/tftpboot/s390x/ which contains the following lines:


    /images/RHEL-5-Server-U3-s390x/kernel.img
    /images/RHEL-5-Server-U3-s390x/initrd.img
    ks=http://cobbler.example.com/cblr/svc/op/ks/system/z01


The file parameter file (s_''systemname''_parm) is intended for kernel options, and may also contain network-specific information for the guest. The config file (s_''systemname''_conf) is intended for CMS specific configuration. It is currently unused, as the parm file contains everything necessary for install. However, it is maintained as a placeholder for additional functionality.

A sample parameter file looks like this:

    LAYER2=0 NETTYPE=qeth PORTNO=0 ip=False MTU=1500
    SEARCHDNS=search.example.com DNS=192.168.5.1 GATEWAY=192.168.5.254
    DASD=100-101,200 NETWORK=192.168.5.0 RUNKS=1 cmdline root=/dev/ram0
    HOSTNAME=server.example.com IPADDR=192.168.5.2
    SUBCHANNELS=0.0.0600,0.0.0601,0.0.0602 BROADCAST=192.168.5.255
    NETMASK=255.255.255.0 PORTNAME=UNASSIGNED ramdisk_size=40000 ro cms

NOTE: The parameter file has several restrictions on content.  The most notable restrictions are listed below.  For a complete list of restrictions, refer to http://www.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/5/html/Installation_Guide/s1-s390-steps-vm.html.

 * The parameter file should contain no more than 80 characters per line.
 * The VM reader has a limit of 11 lines for the parameter file (for a total of 880 characters). 

If there is no system record available on the server, or if netboot is not enabled, zPXE will attempt to retrieve the file profile_list, containing a list of all available install trees.  These are presented in the form of a menu which is displayed at each logon.  If a profile is chosen, zPXE downloads the appropriate kernel and initial RAMdisk and begins the installation.  Note that since these are generic profiles, there is no network-specific information available for this guest, so you will be prompted for this information in the 3270 console during installation.

If you press Enter at the menu without choosing a profile, zPXE will IPL the default disk specified in ZPXE CONF.  If the guest is XAUTOLOG'd (logged on disconnected by another user), zPXE will check for the presence of a system record.  If not found, the default disk is IPL'd with no profile list shown.
