---
layout: manpage
title: Cobbler Import
meta: 2.4.0
---

The purpose of "cobbler import" is to  set up a network install server for one or more distributions. This mirrors content based on a DVD image, an ISO file, a tree on a mounted filesystem, an external rsync mirror or SSH location.

{% highlight bash %}
$ cobbler import --path=/path/to/distro --name=F12
{% endhighlight %}

This example shows the two required arguments for import: --path and --name. 

## Alternative set-up from existing filesystem

_(<b>Note:</b> the description of "--available-as" is probably inadequate.)_

What if you don't want to mirror the install content on your
install server? Say you already have the trees from all your DVDs
and/or CDs extracted on a Filer mounted over NFS somewhere. This
works too, with the addition of one more argument:

    cobbler import --path=/path/where/filer/is/mounted --name=filer \
      --available-as=nfs://nfsserver.example.org:/is/mounted/here 

The above command will set up cobbler automatically using all of
the above distros (stored on the remote filer) -- but will keep the
trees on NFS. This saves disk space on the Cobbler server. As you
add more distros over time to the filer, you can keep running the
above commands to add them to Cobbler.

## Importing Trees

_(<b>Note:</b> this topic was imported from "Advanced Topics", and needs to be more properly integrated into this document.)_

_(<b>Note:</b> the description of "--available-as" is probably inadequate.)_


Cobbler can auto-add distributions and profiles from remote sources, whether this is a filesystem path or an rsync mirror.  This can save a lot of time when setting up a new provisioning environment.  Import is a feature that many users will want to take advantage of, and is very simple to use.

After an import is run, cobbler will try to detect the distribution type and automatically assign kickstarts.  By default, it will provision the system by erasing the hard drive, setting up eth0 for dhcp, and using a default password of "cobbler".  If this is undesirable, edit the kickstart files in `/var/lib/cobbler/kickstarts` to do something else or change the kickstart setting after cobbler creates the profile.

Mirrored content is saved automatically in `/var/www/cobbler/ks_mirror`.

    Example1:  cobbler import --path=rsync://mirrorserver.example.com/path/ --name=fedora --arch=x86

    Example2:  cobbler import --path=root@192.168.1.10:/stuff --name=bar

    Example3:  cobbler import --path=/mnt/dvd --name=baz --arch=x86_64

    Example4:  cobbler import --path=/path/to/stuff --name=glorp

    Example5:  cobbler import --path=/path/where/filer/is/mounted --name=anyname \
      --available-as=nfs://nfs.example.org:/where/mounted/

Once imported, run a "cobbler list" or "cobbler report" to see what you've added.

By default, the rsync operations will exclude content of certain architectures, debug RPMs, and ISO images -- to change what is excluded during an import, see `/etc/cobbler/rsync.exclude`.

Note that all of the import commands will mirror install tree content into `/var/www/cobbler` unless a network accessible location is given with --available-as.  --available-as will be primarily used when importing distros stored on an external NAS box, or potentially on another partition on the same machine that is already accessible via http:// or ftp://.

For import methods using rsync, additional flags can be passed to rsync with the option --rsync-flags.

Should you want to force the usage of a specific cobbler kickstart template for all profiles created by an import, you can feed the option --kickstart to import, to bypass the built-in kickstart auto-detection.

## Kickstarts

Kickstarts are answer files that script the installation of the OS.
Well, for Fedora and Red Hat based distributions it is called
kickstart. We also support other distributions that have similar
answer files, but let's just use kickstart as an example for now.
The kickstarts automatically assigned above will install physical
machines (or virtual machines -- we'll get to that later) with a
default password of "cobbler" (don't worry, you can change these
defaults) and a really basic set of packages. For something more
complicated, you may wish to edit the default kickstarts in
/var/lib/cobbler/kickstarts. You could also use cobbler to assign
them new kickstart files. These files are actually
[Kickstart Templates](Kickstart Templating), a level
beyond regular kickstarts that can make advanced customizations
easier to achieve. We'll talk more about that later as well.

## Associated server set-up

### Firewall

Depending on your usage, you will probably need to make sure
iptables is configured to allow access to the right services.
Here's an example configuration:

    # Firewall configuration written by system-config-securitylevel
    # Manual customization of this file is not recommended.
    *filter
    :INPUT ACCEPT [0:0]
    :FORWARD ACCEPT [0:0]
    :OUTPUT ACCEPT [0:0]
    
    -A INPUT -p icmp --icmp-type any -j ACCEPT
    -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    
    # LOCALHOST
    -A INPUT -i lo -j ACCEPT
    
    # SSH
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
    # DNS - TCP/UDP
    -A INPUT -m state --state NEW -m udp -p udp --dport 53 -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 53 -j ACCEPT
    # DHCP
    -A INPUT -m state --state NEW -m udp -p udp --dport 68 -j ACCEPT
    # TFTP - TCP/UDP
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 69 -j ACCEPT
    -A INPUT -m state --state NEW -m udp -p udp --dport 69 -j ACCEPT
    # NTP
    -A INPUT -m state --state NEW -m udp -p udp --dport 123 -j ACCEPT
    # HTTP/HTTPS
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
    # Syslog for cobbler
    -A INPUT -m state --state NEW -m udp -p udp --dport 25150 -j ACCEPT
    # Koan XMLRPC ports
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 25151 -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 25152 -j ACCEPT
    
    #-A INPUT -j LOG
    -A INPUT -j REJECT --reject-with icmp-host-prohibited
    
    COMMIT

Adapt this to your own environment.

### SELinux

Most likely you are using SELinux since it has been in the Linux mainline since 2.6, as a result you'll need to allow network access from the Apache web server.

    setsebool -P httpd_can_network_connect true

### Services

Depending on whether you are running DHCP and DNS on the same box,
you will want to enable various services:

    /sbin/service httpd start
    /sbin/service dhcpd start
    /sbin/service xinetd start
    /sbin/service cobblerd start
    
    /sbin/chkconfig httpd on
    /sbin/chkconfig dhcpd on
    /sbin/chkconfig xinetd on
    /sbin/chkconfig tftp on
    /sbin/chkconfig cobblerd on

This command "cobbler check" should inform you of most of this.

## Using the server

### PXE

PXE for network installation of "bare metal" machines is straightforward.  You need to set up DHCP:

* If the DHCP server is somewhere else, not on the Cobbler server, its administrator should set its "next-server" to specify your cobbler server.

* If you run DHCP locally and want Cobbler manage it for you, set `manage_dhcp` to 1 in `/etc/cobbler/settings`, edit `/etc/cobbler/dhcp.template` to change some defaults, and re-run "cobbler sync". See [DHCP management](DHCP management) for further details.

Once you get PXE set up, all of the bare-metal compatible profiles
will, by name, show up in PXE menus when the machines network boot.
Type "menu" at the prompt and choose one from the list. Or just
don't do anything and the machine will default through to local
booting. (Some Xen paravirt profiles will not show up, because you
cannot install these on physical machines -- this is intended)

Should you want to pin a particular system to install a particular
profile the next time it reboots, just run:

        cobbler system add --name=example --mac=$mac-address --profile=$profile-name 

Then the above machine will boot directly to the profile of choice
without bringing up the menu. Don't forget to read the manpage docs
as there are more options for customization and control available.
There are also lots of useful settings described in
/etc/cobbler/settings that you will want to read over.

### Reinstallation

Should you have a system you want to install that Fedora 12 on
(instead of whatever it is running now), right now, you can do
this:

       yum install koan
       koan --server=bootserver.example.com --list=profiles
       koan --replace-self --server=bootserver.example.com --profile=F12-i386
       /sbin/reboot

The system will install the new operating system after rebooting,
hands off, no interaction required.

Notice in the above example "F12-i386" is just one of the boring
default profiles cobbler created for you. You can also create your
own, for instance "F12-webservers" or "F12-appserver" -- whatever
you would like to automate.

### Virtualization

Want to install a virtual guest instead (perhaps Xen or KVM)? No
problem.

        yum install koan
        koan --server=bootserver.example.com --virt --virt-type=xenpv --profile=F12-i386-xen

Done.

You can also use KVM or other virtualization methods. These are
covered elsewhere on the Wiki. Some distributions have Xen specific
profiles you need to use, though this is merged back together
starting with Fedora 12.
