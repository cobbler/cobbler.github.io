---
layout: post
title: Secure Boot
author: Phil
summary: Configuring PXE Secure Boot
---

Note: this has only been tested on a CentOS7 Cobbler 2.8 server to deploy CentOS7/8 and RHEL7/8 hosts.

The complication of secure boot is that all stages of the boot loading need to be vendor specific.
So the DHCP configuration needs to have a system specific `filename` defined. As you need the
flexibility to set this value at each level of the distro/profile/system hierarchy, this process uses
the ksmeta facility.

Note: release 2.8.5 and below do not support passing ksmeta values to the dhcp.template and therefore
you must apply this simple one-line pull request [#2180](https://github.com/cobbler/cobbler/pull/2180)

The ksmeta value for `filename` needs to be set to the first stage loader for the OS. For 64bit
RHEL based distros this is the `shimx64.efi`. This then loads the `grubx64.efi` which finally loads the
host(MAC) specific config file `grub.cfg-01-MAC`. Because these filenames are fixed you have to put them
in a distro specific sub-directory. Also `grubx64.efi` will fetch the config files from the same sub-directory.

The steps to get this working are:

1) Apply the patch from PR [#2180](https://github.com/cobbler/cobbler/pull/2180) if required.

2) Extract the `shimx64.efi` and `grubx64.efi` from the distro’s `shim-x64` and `grub2-efi-x64` RPMs.

3) Place these two files in a distro specific sub-directory of `/var/lib/cobbler/loaders/`,
e.g. `/var/lib/cobbler/loaders/rhel8-x86_64/shimx64.efi`.

4) Set the filename ksmeta at an appropriate level, e.g. --ksmeta “filename=grub/rhel8-x86_64/shimx64.efi”

5) In the `/etc/cobbler/dhcp.template` add a check for the `filename` in the `mgmt_parameters`:

{% highlight bash %}
<snip>
#for dhcp_tag in $dhcp_tags.keys():
group {
        #for mac in $dhcp_tags[$dhcp_tag].keys():
            #set iface = $dhcp_tags[$dhcp_tag][$mac]
    host $iface.name {
        hardware ethernet $mac;
<snip>
        #if $iface.mgmt_parameters.get('filename')
        filename "$iface.mgmt_parameters.get('filename')";
        #end if
    }
        #end for
}
#end for
{% endhighlight %}

6) Update the `/etc/cobbler/pxe/grubsystem.template` to also check for `filename`. This is required as
the file format is different:

{% highlight bash %}
default=0
timeout=0

#if $mgmt_parameters.get('filename')

menuentry '$system_name' {
    linuxefi $kernel_path $kernel_options
    initrdefi $initrd_path
}

#else

title $system_name
    root (nd)
    kernel $kernel_path $kernel_options
    initrd $initrd_path

#end if
{% endhighlight %}

7) Add a post sync trigger `/var/lib/cobbler/triggers/sync/post/secure-boot` and make it executable. This copies
in the distro specific boot loaders and links in the config files with the name required by `grubx64.efi`:

{% highlight bash %}
#!/bin/bash

for loader in /var/lib/cobbler/loaders/*
do
  if [ -d "${loader}" ]
  then
    cp -r ${loader} /var/lib/tftpboot/grub/

    (
      cd /var/lib/tftpboot/grub/$(basename ${loader})

      for p in ../01-*
      do
        f=$(basename $p)
        f=${f,,}
        ln -sf $p grub.cfg-$f
      done
    )
  fi
done
{% endhighlight %}

8) Do a `cobbler sync`.

You should now have the loaders copied into distro specific sub-directories of `/var/lib/tftpboot/grub/`, e.g.
`/var/lib/tftpboot/grub/rhel8-x86_64`, and the `filename` should be set for each system in the
generated `/etc/dhcp/dhcpd.conf`, e.g.

{% highlight bash %}
    host myserver-eno1 {
        hardware ethernet ec:eb:58:98:79:78;
        fixed-address 10.0.0.101;
        option host-name "myserver";
        option subnet-mask 255.255.255.0;
        next-server 10.0.0.2;
        filename "grub/rhel7-x86_64/shimx64.efi";
    }
{% endhighlight %}

