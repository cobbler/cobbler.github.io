---
layout: manpage
title: Cobbler Manual
---
# All about images

The primary and recommended use of cobbler is to deploy systems by building them, as though from the OS manufacturer's distribution, e.g Redhat kickstart.  This method is generally easier to work with and provides an infrastructure which is not only more sustainable but also much more flexible across varieties of hardware.

But Cobbler can help with image-based booting, physically and virtually. Some manual use of other commands beyond what is typically required of cobbler may be needed to prepare images for use with this feature, and the usage of these commands varies substantially by the type of image.

There is a lot more to go here.  For the moment we just have 1 example of using the "memdisk" image type

## memdisk

### Oracle / Sun Maintenance CD

The 'memdisk' image type can be used to PXE boot Oracle / Sun maintenance CDs.  [Their manual](http://docs.oracle.com/cd/E19121-01/sf.x2250/820-4593-12/AppB.html#50540564_72480) gives details on how to copy the boot CD to a PXE server.  The procedure is even easier with cobbler since the system takes care of most of that stuff for you.

Take your ISO for the boot CD and mount is as a loopback mount somewhere on your cobbler server, and then copy the 'boot.img' file out into your /tftpboot directory.  Then add an image of type "memdisk" which uses it.  As of this writing the following command line command will fail due to a known bug, but the web interface can successfully be used to add the image.  

> cobbler image add --name=MyName --image-type=memdisk --file=/tftpboot/oracle/SF2250/boot.img
> usage: cobbler [options]
>
> cobbler: error: option --image-type: invalid choice: 'memdisk' (choose from 'iso', 'direct', 'virt-image')
> 

The error is noted above.  But as mentioned, the web GUI works fine for this.

Once that is done you are golden - that simple.   Just boot your machine from the network and select the image "MyName".