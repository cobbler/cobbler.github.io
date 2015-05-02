---
layout: manpage
title: Cobbler Quickstart Guide
meta: 2.6.0
---

Cobbler can be a somewhat complex system to get started with, due to the wide variety of technologies it is designed to manage, but it does support a great deal of functionality immediately after installation with little to no customization needed. Before getting started with cobbler, you should have a good working knowledge of PXE as well as the automated installation methodology of your choosen distribution. 

This quickstart guide will focus on the Red Hat kickstart process, which is very mature and well-tested. In the future, we will be adding quickstart guides for other distributions, such as Ubuntu and SuSE. The steps below will be focused on Fedora (specifically version 17), however they should work for any Red Hat-based distribution, such as RHEL, CentOS, or Scientific Linux. Please see the {% linkup title:"Installing Cobbler" extrameta:2.6.0 %} section for details on installation and prerequisites for your specific OS version.

Finally, this guide will focus only on the CLI application. For more details regarding cobbler's web UI, go here: {% linkup title:"Cobbler Web User Interface" extrameta:2.6.0 %}

## Disable SELinux (optional)

Before getting started with cobbler, it may be a good idea to either disable SELinux or set it to "permissive" mode, especially if you are unfamiliar with SELinux troubleshooting or modifying SELinux policy. Cobbler constantly evolves to assist in managing new system technologies, and the policy that ships with your OS can sometimes lag behind the feature-set we provide, resulting in AVC denials that break cobbler's functionality.

If you would like to continue using SELinux on the system running cobblerd, be sure to read the {% linkup title:"SELinux With Cobbler" extrameta:2.6.0 %} section in this manual.

## Installing Cobbler

Installation is done simply through yum:

{% highlight bash %}
$ yum install cobbler
{% endhighlight %}

This will pull in all of the requirements you need for a basic setup.

## Changing Settings

Before starting the cobblerd service, there are a few things you should modify.

Settings for cobbler/cobblerd are stored in `/etc/cobbler/settings`. This file is a YAML formatted data file, so be sure to take care when editing this file as an incorrectly formatted file will prevent cobbler/cobblerd from running. 

### Default Encrypted Password 

This setting controls the root password that is set for new systems during the kickstart. 

{% highlight yaml %}
default_password_crypted: "$1$bfI7WLZz$PxXetL97LkScqJFxnW7KS1"
{% endhighlight %}

You should modify this by running the following command and inserting the output into the above string (be sure to save the quote marks):

{% highlight bash %}
$ openssl passwd -1
{% endhighlight %}

### Server and Next_Server

The server option sets the IP that will be used for the address of the cobbler server. **_DO NOT_** use 0.0.0.0, as it is not the listening address. This should be set to the IP you want hosts that are being built to contact the cobbler server on for such protocols as HTTP and TFTP.

{% highlight yaml %}
# default, localhost
server: 127.0.0.1
{% endhighlight %}

The next_server option is used for DHCP/PXE as the IP of the TFTP server from which network boot files are downloaded. Usually, this will be the same IP as the server setting.

{% highlight yaml %}
# default, localhost
next_server: 127.0.0.1
{% endhighlight %}

### DHCP Management and DHCP Server Template

In order to PXE boot, you need a DHCP server to hand out addresses and direct the booting system to the TFTP server where it can download the network boot files. Cobbler can manage this for you, via the manage_dhcp setting:

{% highlight yaml %}
# default, don't manage
manage_dhcp: 0
{% endhighlight %}

Change that setting to 1 so cobbler will generate the dhcpd.conf file based on the dhcp.template that is included with cobbler. This template will most likely need to be modified as well, based on your network settings:

{% highlight bash %}
$ vi /etc/cobbler/dhcp.template
{% endhighlight %}

For most uses, you'll only need to modify this block:

{% highlight cheetah %}
subnet 192.168.1.0 netmask 255.255.255.0 {
     option routers             192.168.1.1;
     option domain-name-servers 192.168.1.210,192.168.1.211;
     option subnet-mask         255.255.255.0;
     filename                   "/pxelinux.0";
     default-lease-time         21600;
     max-lease-time             43200;
     next-server                $next_server;
}
{% endhighlight %}

No matter what, make sure you do not modify the "next-server $next_server;" line, as that is how the next_server setting is pulled into the configuration. This file is a cheetah template, so be sure not to modify anything starting after this line:

{% highlight cheetah %}
#for dhcp_tag in $dhcp_tags.keys():
{% endhighlight %}

Completely going through the dhcpd.conf configuration syntax is beyond the scope of this document, but for more information see the man page for more details:

{% highlight bash %}
$ man dhcpd.conf
{% endhighlight %}

## Files and Directory Notes

Cobbler makes heavy use of the `/var` directory. The `/var/www/cobbler/ks_mirror` directory is where all of the distribution and repository files are copied, so you will need 5-10GB of free space per distribution you wish to import. 

If you have installed cobbler onto a system that has very little free space in the partition containing `/var`, please read the {% linkup title:"Relocating Your Installation" extrameta:2.6.0 %} section of the manual to learn how you can relocate your installation properly.

## Starting and Enabling the Cobbler Service

Once you have updated your settings, you're ready to start the service. Fedora now uses systemctl to manage services, but you can still use the regular init script:

{% highlight bash %}
$ systemctl start cobblerd.service
$ systemctl enable cobblerd.service
$ systemctl status cobblerd.service
# or 
$ service cobblerd start 
$ chkconfig cobblerd on
$ service cobblerd status
{% endhighlight %}

If everything has gone well, you should see output from the status command like this:

{% highlight bash %}
cobblerd.service - Cobbler Helper Daemon
          Loaded: loaded (/lib/systemd/system/cobblerd.service; enabled)
          Active: active (running) since Sun, 17 Jun 2012 13:01:28 -0500; 1min 44s ago
        Main PID: 1234 (cobblerd)
          CGroup: name=systemd:/system/cobblerd.service
                  └ 1234 /usr/bin/python /usr/bin/cobblerd -F
{% endhighlight %}

## Checking for Problems and Your First Sync

Now that the cobblerd service is up and running, it's time to check for problems. Cobbler's check command will make some suggestions, but it is important to remember that _these are mainly only suggestions_ and probably aren't critical for basic functionality. If you are running iptables or SELinux, it is important to review any messages concerning those that check may report.

{% highlight bash %}
$ cobbler check
The following are potential configuration items that you may want to fix:

1. ....
2. ....

Restart cobblerd and then run 'cobbler sync' to apply changes.
{% endhighlight %}

If you decide to follow any of the suggestions, such as installing extra packages, making configuration changes, etc., be sure to restart the cobblerd service as it suggests so the changes are applied.

Once you are done reviewing the output of "cobbler check", it is time to synchronize things for the first time. This is not critical, but a failure to properly sync at this point can reveal a configuration problem.

{% highlight bash %}
$ cobbler sync
task started: 2012-06-24_224243_sync
task started (id=Sync, time=Sun Jun 24 22:42:43 2012)
running pre-sync triggers
...
rendering DHCP files
generating /etc/dhcp/dhcpd.conf
rendering TFTPD files
generating /etc/xinetd.d/tftp
cleaning link caches
running: find /var/lib/tftpboot/images/.link_cache -maxdepth 1 -type f -links 1 -exec rm -f '{}' ';'
received on stdout: 
received on stderr: 
running post-sync triggers
running python triggers from /var/lib/cobbler/triggers/sync/post/*
running python trigger cobbler.modules.sync_post_restart_services
running: dhcpd -t -q
received on stdout: 
received on stderr: 
running: service dhcpd restart
received on stdout: 
received on stderr: 
running shell triggers from /var/lib/cobbler/triggers/sync/post/*
running python triggers from /var/lib/cobbler/triggers/change/*
running python trigger cobbler.modules.scm_track
running shell triggers from /var/lib/cobbler/triggers/change/*
*** TASK COMPLETE ***
{% endhighlight %}

Assuming all went well and no errors were reported, you are ready to move on to the next step.

## Importing Your First Distribution

Cobbler automates adding distributions and profiles via the "cobbler import" command. This command can (usually) automatically detect the type and version of the distribution your importing and create (one or more) profiles with the correct settings for you.

### Download an ISO Image

In order to import a distribution, you will need a DVD ISO for your distribution. **NOTE:** You must use a full DVD, and not a "Live CD" ISO. For this example, we'll be using the Fedora 17 x86_64 ISO, [available for download here](http://download.fedoraproject.org/pub/fedora/linux/releases/17/Fedora/x86_64/iso/Fedora-17-x86_64-DVD.iso).

Once this file is downloaded, mount it somewhere:

{% highlight bash %}
$ mount -t iso9660 -o loop,ro /path/to/isos/Fedora-17-x86_64-DVD.iso /mnt
{% endhighlight %}

### Run the Import 

You are now ready to import the distribution. The name and path arguments are the only required options for import:

{% highlight bash %}
$ cobbler import --name=fedora17 --arch=x86_64 --path=/mnt
{% endhighlight %}

The --arch option need not be specified, as it will normally be auto-detected. We're doing so in this example in order to prevent multiple architectures from being found (Fedora ships i386 packages on the full DVD, and cobbler will create both x86_64 and i386 distros by default).

### Listing Objects

If no errors were reported during the import, you can view details about the distros and profiles that were created during the import. 

{% highlight bash %}
# list distros
$ cobbler distro list

# list profiles
$ cobbler profile list
{% endhighlight %}

The import command will typically create at least one distro/profile pair, which will have the same name as shown above. In some cases (for instance when a xen-based kernel is found), more than one distro/profile pair will be created.

### Object Details

The report command shows the details of objects in cobbler:

{% highlight bash %}
$ cobbler distro report --name=fedora17-x86_64
Name                           : fedora17-x86_64
Architecture                   : x86_64
TFTP Boot Files                : {}
Breed                          : redhat
Comment                        : 
Fetchable Files                : {}
Initrd                         : /var/www/cobbler/ks_mirror/fedora17-x86_64/images/pxeboot/initrd.img
Kernel                         : /var/www/cobbler/ks_mirror/fedora17-x86_64/images/pxeboot/vmlinuz
Kernel Options                 : {}
Kernel Options (Post Install)  : {}
Kickstart Metadata             : {'tree': 'http://@@http_server@@/cblr/links/fedora17-x86_64'}
Management Classes             : []
OS Version                     : fedora17
Owners                         : ['admin']
Red Hat Management Key         : <<inherit>>
Red Hat Management Server      : <<inherit>>
Template Files                 : {}
{% endhighlight %}

As you can see above, the import command filled out quite a few fields automatically, such as the breed, OS version, and initrd/kernel file locations. The "Kickstart Metadata" field (--ksmeta internally) is used for miscellaneous variables, and contains the critical "tree" variable. This is used in the kickstart templates to specify the URL where the installation files can be found.

Something else to note: some fields are set to "&lt;&lt;inherit&gt;&gt;". This means they will use either the default setting (found in the settings file), or (in the case of profiles, sub-profiles, and systems) will use whatever is set in the parent object.

## Creating a System

Now that you have a distro and profile, you can create a system. Profiles can be used to PXE boot, but most of the features in cobbler revolve around system objects. The more information you give about a system, the more cobbler will do automatically for you.

First, we'll create a system object based on the profile that was created during the import. When creating a system, the name and profile are the only two required fields:

{% highlight bash %}
$ cobbler system add --name=test --profile=fedora17-x86_64
$ cobbler system list
test
$ cobbler system report --name=test
Name                           : test
TFTP Boot Files                : {}
Comment                        : 
Enable gPXE?                   : 0
Fetchable Files                : {}
Gateway                        : 
Hostname                       : 
Image                          : 
IPv6 Autoconfiguration         : False
IPv6 Default Device            : 
Kernel Options                 : {}
Kernel Options (Post Install)  : {}
Kickstart                      : <<inherit>>
Kickstart Metadata             : {}
LDAP Enabled                   : False
LDAP Management Type           : authconfig
Management Classes             : []
Management Parameters          : <<inherit>>
Monit Enabled                  : False
Name Servers                   : []
Name Servers Search Path       : []
Netboot Enabled                : True
Owners                         : ['admin']
Power Management Address       : 
Power Management ID            : 
Power Management Password      : 
Power Management Type          : ipmitool
Power Management Username      : 
Profile                        : fedora17-x86_64
Proxy                          : <<inherit>>
Red Hat Management Key         : <<inherit>>
Red Hat Management Server      : <<inherit>>
Repos Enabled                  : False
Server Override                : <<inherit>>
Status                         : production
Template Files                 : {}
Virt Auto Boot                 : <<inherit>>
Virt CPUs                      : <<inherit>>
Virt Disk Driver Type          : <<inherit>>
Virt File Size(GB)             : <<inherit>>
Virt Path                      : <<inherit>>
Virt RAM (MB)                  : <<inherit>>
Virt Type                      : <<inherit>>
{% endhighlight %}

The primary reason for creating a system object is network configuration. When using profiles, you're limited to DHCP interfaces, but with systems you can specify many more network configuration options. 

So now we'll setup a single, simple interface in the 192.168.1/24 network:

{% highlight bash %}
$ cobbler system edit --name=test --interface=eth0 --mac=00:11:22:AA:BB:CC --ip-address=192.168.1.100 --netmask=255.255.255.0 --static=1 --dns-name=test.mydomain.com 
{% endhighlight %}

The default gateway isn't specified per-NIC, so just add that separately (along with the hostname):

{% highlight bash %}
$ cobbler system edit --name=test --gateway=192.168.1.1 --hostname=test.mydomain.com
{% endhighlight %}

The --hostname field corresponds to the local system name and is returned by the "hostname" command. The --dns-name (which can be set per-NIC) should correspond to a DNS A-record tied to the IP of that interface. Neither are required, but it is a good practice to specify both. Some advanced features (like configuration management) rely on the --dns-name field for system record look-ups.

Whenever a system is edited, cobbler executes what is known as a "lite sync", which regenerates critical files like the PXE boot file in the TFTP root directory. One thing it will **NOT** do is execute service management actions, like regenerating the dhcpd.conf and restarting the DHCP service. After adding a system with a static interface it is a good idea to execute a full "cobbler sync" to ensure the dhcpd.conf file is rewritten with the correct static lease and the service is bounced.
