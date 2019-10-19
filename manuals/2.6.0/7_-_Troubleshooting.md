---
layout: manpage
title: Frequently Asked Trouble Shooting Questions
meta: 2.6.0
nav: 7 - Troubleshooting
navversion: nav26
---

This section covers some questions that frequently come up in IRC, some of which are problems, and some of which are
things about Cobbler that are not really problems, but are things folks just ask questions about frequently... 

See also [Virtualization Troubleshooting](Virtualization Troubleshooting) for virtualization specific questions. 

# General

## Most Common Things To Check

Have you run Cobbler check? What did it say? Is Cobbler and koan at the most recent released stable version? Is cobblerd
running? Have you tried restarting it if this is a recent upgrade or config change? If something isn't showing up, have
you restarted cobblerd and run "cobbler sync" after making changes to the config file? If you can't connect or retrieve
certain files, is Apache running, or have you restarted it after a new install? If there's a koan connectivity problem,
are there any firewalls blocking port 25150? 

## I am having a problem with importing repos

Trick question! one does not run "cobbler import" on repos :) Install trees contain more data than repositories. Install
trees are for OS installation and are added using `cobbler import` or `cobbler distro add` if you want do something more
low level. Repositories are for things like updates and additional packages. Use `cobbler repo add` to add these
sources. If you accidentally import a repo URL (for instance using rsync), clean up
`/var/www/cobbler/ks_mirror/name_you_used` to take care of it. Cobbler can't detect what you are importing in advance
before you copy it. Thankfully `man cobbler` gives plenty of good examples for each command, `cobbler import` and
`cobbler repo add` and gives example URLs and syntaxes for both. 

See also [Using Cobbler Import](Using Cobbler Import) and [Manage Yum Repos](Manage Yum Repos) for further information. 

## Why do the kickstart files in /etc/cobbler look strange?

These are not actually kickstart files, they are kickstart file templates. See
[Kickstart Templating](Kickstart Templating) for more information. 

## How can I validate that my kickstarts are right before installing?

Try `cobbler validateks`

## Can I feed normal kickstart files to --kickstart ?

You can, but you need to escape any dollar signs ($) with (\$) so the Cobbler templating engine doesn't eat them. This
is not too hard, use `cobbler profile getks` and `cobbler system getks` to make sure everything renders correctly. Also
\#raw ... #endraw in Cheetah can be useful. More is documented on the [Kickstart Templating](Kickstart Templating) page. 

## My kickstart file has problems

If it's not related to Cobbler's [Kickstart Templating](Kickstart Templating) engine, and it's more of "how do I do this
in pre/post", kickstart-list is excellent. 

[http://www.redhat.com/mailman/listinfo/kickstart-list](http://www.redhat.com/mailman/listinfo/kickstart-list) 

Also be sure to read the archives, I have created a Google custom search engine for this
[here](http://www.google.com/coop/cse?cx=016811804524159694721:1h7btspnxtu). 

Otherwise, you are likely seeing a Cheetah syntax error. Learn more about Cheetah syntax at
[http://cheetahtemplate.org/learn](http://cheetahtemplate.org/learn) for further information. 

## I'm running into the 255 character kernel options line limit

This can be a problem. Adding a CNAME for your cobbler server that is accessible everywhere, such as "cobbler", or even
"boot" can save a lot of characters over hostname.xyz.acme-corp.internal.org. It will show up twice in the kernel
options line, once for the kickstart URL, and once for the kickstart URL. Save characters by not using FQDNs when
possible. The IP may also be shorter in some cases. Cobbler should try to remove optional kernel args in the event of
overflow (like syslog) but you still need to be careful. 

(Newer kernels are supposed to not have this limit) 

## I'm getting PXE timeouts and my cobbler server is also a virtualized host and I'm using dnsmasq for DHCP

Libvirtd starts an instance of dnsmasq unrelated to the DHCP needed for cobbler to PXE -- it's just there for local
networking but can cause conflicts. If you want PXE to work, do not run libvirtd on the cobbler server, or use ISC dhcpd
instead. You can of course run libvirtd on any other guests in your management network, and if you don't need PXE
support, running libvirtd on the cobbler server is also fine. 

Alternatively you can configure your DHCP server not to listen on all interfaces: dnsmasq run by libvirtd is configured
to listen on `internal virbr0/192.168.122.1` only. For ISC dhcpd you can set in `/etc/sysconfig/dhcpd`: 

````
DHCPDARGS=eth0
````

For dnsmasq you can set in `/etc/dnsmasq.conf`: 

````
interface=eth0
except-interface=lo
bind-interfaces
````

## I'm having DHCP timeouts / DHCP is slow / etc

See the Anaconda network troubleshooting page:
[http://fedoraproject.org/wiki/Anaconda/NetworkIssues](http://fedoraproject.org/wiki/Anaconda/NetworkIssues) 

This URL has "Fedora" in it, but applies equally to Red Hat and derivative distributions. 

## Cobblerd won't start

cobblerd won't start and say: 

````
Starting cobbler daemon: Traceback (most recent call last):
  File "/usr/bin/cobblerd", line 76, in main
    api = cobbler_api.BootAPI(is_cobblerd=True)
  File "/usr/lib/python2.6/site-packages/cobbler/api.py", line 127, in <strong>init</strong>
    module_loader.load_modules()
  File "/usr/lib/python2.6/site-packages/cobbler/module_loader.py", line 62, in load_modules
    blip =  <strong>import</strong>("modules.%s" % ( modname), globals(), locals(), [modname])
  File "/usr/lib/python2.6/site-packages/cobbler/modules/authn_pam.py", line 53, in <module>
    from ctypes import CDLL, POINTER, Structure, CFUNCTYPE, cast, pointer, sizeof
  File "/usr/lib64/python2.6/ctypes/<strong>init</strong>.py", line 546, in <module>
    CFUNCTYPE(c_int)(lambda: None)
MemoryError
                                                           [  OK  ]

Check your SELinux. Immediate fix is to disable selinux: 
setenforce 0
````
