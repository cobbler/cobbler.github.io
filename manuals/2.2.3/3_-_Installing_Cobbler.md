---
layout: manpage
title: Installing Cobbler
---
## Installation And Basics

Start here to learn about what Cobbler can do and how to set it up.

  * [Download Instructions](Download Instructions) -- Download instructions for RPMs and DEB files, and how to set up yum to be able to get Cobbler updates.
  * [Start Here](Start Here) -- a little about everything (in process of being split up into subpages)
  * [Using Cobbler Import](Using Cobbler Import) -- Guide on how to import distributions from DVD or mirrors and get going quickly.   Everyone should read this.
  * [Cobbler Web Interface](Cobbler Web Interface) -- using the Cobbler Web interface, and how to set it up.  The Web UI is optional if you prefer the command line.
  * [How We Model Things](How We Model Things) -- the different object types in cobbler and how we represent your configuration for easy manipulation
  * [Koan](Koan) -- using Cobbler's helper tool on nodes to reinstall, install, and update themselves (pull style)
  * [Distribution Support](Distribution Support) -- notes on levels of support for different platforms
  * [Advanced Topics](Advanced Topics) -- an overview of various advanced features that may be covered elsewhere in the Wiki in greater depth.  A vestige of the old manpage docs, this is getting broken out below.

## Core Features -- Start Here

### Physical Machine Installation

One of the main features of Cobbler is help you roll out new physical machines in a fully-automated way.

  * Basic PXE setup is described in [Using Cobbler Import](Using Cobbler Import)
  * [Manage Yum And Apt Repos](Manage Yum Repos) -- how to use cobbler to mirror updates as well as just do installs
  * [Reinstallation](Reinstallation) -- how to use Koan for adding a reinstall option to grub, for when PXE is not possible
  * [Build Iso](Build Iso) - when you need to install baremetal systems in an automated way and can't use PXE and/or DHCP infrastructure, Cobbler provides alternatives

### Virtualization Automation

Koan can be used (run on the host machines, talks to cobbler) to help automate virtual machine installation.   This is one of the primary functions of Cobbler -- to serve installs of not only physical machines, but also virtual ones.   Of course, you don't always need to use koan -- for example, let Cobbler manage your PXE tree, and just PXE boot from VMware.  But when you do, koan has lots of helpful options to automate the parameters in and around virtual installs.

  * [Installing Virtual Guests](Installing Virtual Guests)-- an overview of how to do virtualization installs with koan+cobbler, start here
  * [Virtual Networking Setup](Virtual Networking Setup) -- virtual networking setup for use with koan
  * [VMWare](VMware) -- how to use Koan with VMware instead of Xen or qemu/KVM

## Intermediate Features (A La Carte Usage Ok)

### Kickstart Templating 

One of the main features of Cobbler is a kickstart templating engine that can help users tame a sea of unruly kickstarts for automating their OS and application installations, making it possible to share Snippets of code between them, or substitute variables into kickstart files.

  * [Kickstart Templating](Kickstart Templating) -- examples using Cobbler with profile and system specific kickstart templating 
  * [Kickstart Snippets](Kickstart Snippets) -- a cookbook of snippets for use in kickstart templates
  * [Extending Cheetah](Extending Cheetah) -- for those of you who really want to get carried away with kickstart templating (Advanced Topic!)

### Package Update Mirroring Features

Packages are closely related to installation.   Cobbler can help you mirror updates as well, and ensure that installed systems are configured to get those updates that you mirror.  In some cases, you can also make sure systems are up to date with all of the latest packages at the end of OS installation.

 * [Package Management and Mirroring](Package Management and Mirroring) : using Cobbler to manage yum repositories for fun and profit 

### Network Management Features

DHCP and DNS are low level network services closely related to (and needed for) installation.   Cobbler can optionally help you keep your DHCP and DNS configurations manageable.  It can also help you configure advanced network features not neccessarily supported natively in kickstart, including bonding and VLANs.  If you don't want to use these advanced options, you can just set up DHCP to point to your PXE server and not have Cobbler manage it -- which is a perfectly fine thing to do.  However, if you'd like to get out of the game of editing DHCP/DNS configuration files, this section is for you.

  * [DHCP Management](DHCP Management) -- cobbler can take care of DHCP management for you also
  * [DNS Management](DNS Management) -- cobbler can use BIND for DNS management
  * [Advanced Networking](Advanced Networking) -- Using Cobbler to deploy advanced networking configurations (bonding and VLANs are covered here)

### Usage with Redhat-based systems

* [Hints and tips for Redhat](Hints-redhat) :  rescue-mode etc.

### Usage with Red Hat Enterprise Linux

Cobbler supports many varieties of Linux, but here are some special tips for making RHEL management easier.

  * [Tips for RHN](Tips For RHN) :  Ways to make cobbler/RHN/RHEL life even easier
  * We recommend that RHEL users configure EPEL-testing as a repository
  * Satellite 5.3 and beyond have an embedded (older) Cobbler server, see also http://fedorahosted.org/spacewalk, but we recommend that you just use Cobbler directly and will have access to more options.

### Continued Management of Installed Systems

Cobbler can either be its own (very simple) configuration management system or can help you out to use another configuration management system (like Puppet) alongside it.

  * [Built-in Configuration Management](Built In Configuration Management) : using cobbler as a lightweight configuration management system
  * [Using Cobbler With A Configuration Management System](Using Cobbler With A Configuration Management System) : different ways to control the mappings between cobbler and things like Puppet
  * [Func Integration](Func Integration) : even easier [http://fedorahosted.org/func Func] setup with Cobbler

### Using Cobbler for Power Management (Optional)

Cobbler can help you control systems in diverse power management environments, including helping you out with virtual systems.

  * [Power Management](Power Management)

### Simple Cobbler Tips And Tricks

Some useful things that don't fit into other categories.

  * [Command line search](Command line search) : ask questions about your configuration using the command line.
  * [Batch Editing](Batch Editing) : Want to edit a lot of objects at once?
  * [Memtest](Memtest): How cobbler auto-discovers memtest and adds it automatically to your PXE menus
  * [Graphical Installs](Graphical Installs) : How do I do graphical installs?   Easy.
  * [How to Boot Live CDs](How To Boot Live CDs) : How do you boot a linux live CD over PXE?
  * [All About Images](All About Images): Some options for dealing with things that don't fall into the kernel+initrd model
  * [Filesystem ACLs](Filesystem ACLs): use "cobbler aclsetup" to grant cobbler usage to non-root users (instead of granting sudo access)

## Advanced Operations

### Misc. Advanced Tips And Tricks

For more complex environments, a simple netboot infrastructure and a single install server is not enough.  If you have a large number of systems, a static network, or special requirements, items in this section may be for you.   If you have a simple DHCP network with one Cobbler server, you can probably ignore this section for now and read about these features later as you need them.

  * [Deploy Feature](Deploy Feature): Easier virt deployment all in one central place using a variety of transports
  * [Replication](Replication): cobbler can replicate configurations to other cobbler servers for performance and disaster recovery
  * [Build Iso](Build Iso): How to build net install CD's with a menu of all of your profiles on them, in one easy step
  * [Anaconda Monitoring](Anaconda Monitoring) : Using the anaconda installation monitoring feature for tracking and logging install progress remotely *DEPRECATED*
  * [System Retirement and Secure Erasure](System Retirement): how to securely wipe a system with Cobbler and DBAN
  * [Auto Registration](Auto Registration) : how to create Cobbler System records during PXE
  * [Multiple Cobbler Server Addresses](Multiple Cobbler Server Addresses)
  * [Power PC Support](Power PC Support) : How to use yaboot to simulate PXE to network boot your systems.
  * [S390 Support](S390 Support) : How to use the zpxe PXE simulator that is built into cobbler, and how it works
  * [Clonezilla Integration](Clonezilla Integration) : How to use clonezilla-live with cobbler for duplicating any OS type
  * [Microsoft Systems Center](Microsoft Systems Center) : How to add a PXE menu item that will boot a SCCM install CD *DEPRECATED*
  * [PXE Boot Menu Passwords](PXE Boot Menu Passwords) : How to set a password on the PXE menu

### Using Cobbler for Firmware Updates

Here are some instructions for using Cobbler to push out Vendor specific firmware updates

  * [HP Firmware Updates](HP Firmware Updates) : using Cobbler to update firmware on HP Proliant hardware
  * [Dell Firmware Updates](Dell Firmware Updates) : using Cobbler to update Dell firmware 


### Cobbler Server Migrations

If you need to move Cobbler to another machine or change where it is storing data, this section is for you.
 
  * [Relocating Your Install](Relocating Your Install) : what if I don't want cobbler data in my /var partition?
  * [Moving Your Install](Moving Your Install) : How do you go about moving your cobbler install to another box?

### Security Choices (for WebUI / XMLRPC)

What sort of security controls are available for the web application and XMLRPC API consumers?

  * [Security Overview](Security Overview) -- general security overview on how to define your security policy 
  * [Web Authentication](Web Authentication) -- choose what to autheticate against
      * [Kerberos](Kerberos) -- how to authenticate against Kerberos
      * [LDAP](LDAP) -- how to authenticate against Ldap
  * [Web Authorization](Web Authorization) -- choose what users get what access controls
  * [Lock Down](Lock Down) -- if you're a multi-user cobbler install, mdehaan's recommendations.  Also includes SELinux notes.

See the developer documentation page for more about API integration options.

### Internals

  * [File System Information](File System Information) -- what lives where in a cobbler install, and where the important files are at.

## Troubleshooting 

A list of resources to look into when encountering problems with Cobbler, virtualization, kickstart, and related IT infrastructure

  * [TroubleShooting](Troubleshooting) (basically a Cobbler FAQ)
  * [Virtualization Troubleshooting](Virtualization Troubleshooting) (specifically related to cobbler+koan and virtualization)
  * [Anaconda Network Issues](http://fedoraproject.org/wiki/Anaconda/NetworkIssues) -- it's not our fault
  * [RHEL docs on kickstart options](http://www.redhat.com/docs/manuals/enterprise/RHEL-5-manual/Installation_Guide-en-US/s1-kickstart2-options.html)
  * [Fedora docs on kickstart options](http://fedoraproject.org/wiki/Anaconda/Option) 
  * [SuSE AutoYaST documentation](http://www.suse.de/~ug/ SuSE AutoYast documentation)
  * [Kickstart mailing list](http://www.redhat.com/mailman/listinfo/kickstart-list)
  * [Kickstart mailing list custom search engine](http://www.google.com/coop/cse?cx=016811804524159694721%3A1h7btspnxtu)
  * [Cobbler mailing list custom search engine](http://www.google.com/coop/cse?cx=016811804524159694721:pfx-ny1pn3s)

If you're still stuck, join the mailing list, as we have a large community of experienced admins.  See details at [cobbler.github.com](cobbler.github.com).
