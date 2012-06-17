---
layout: manpage
title: Cobbler Manual - File System Information
meta: 2.2.3
---
A typical cobbler install looks something as follows. Note that in
general cobbler manages its own directories. Editing templates and
configuration files is intended. Deleting directories will result
in very loud alarms. Please do not ask for help if you decide to
delete core directories or move them around.

See [Relocating Your Install](Relocating Your Install) if
you have space problems.

## /var/log/cobbler

All cobbler logs go here. cobbler does not dump to
/var/log/messages, though other system services relating to
netbooting do.

## /var/www/cobbler

This is a cobbler owned and managed directory for serving up
various content that we need to serve up via http. Further selected
details are below. As tempting as it is to self-garden this
directory, do not do so. Manage it using the "cobbler" command or
the Cobbler web app.

## /var/www/cobbler/web/

Here is where the mod\_python web interface and supporting service
scripts live for Cobbler pre 2.0

## /usr/share/cobbler/web

This is where the cobbler-web package (for Cobbler 2.0 and later)
lives. It is a Django app.

## /var/www/cobbler/webui/

Here is where content for the (pre 2.0) webapp lives that is not a
template. Web templates for all versions live in
/usr/share/cobbler.

## /var/www/cobbler/aux/

This is used to serve up certain scripts to anaconda, such as
[AnaMon](/cobbler/wiki/AnaMon)

## /var/www/cobbler/svc/

Here code for auxillary web services lives, see
[ModPythonDetails](/cobbler/wiki/ModPythonDetails) for exactly what
those URLs and services are.

## /var/www/cobbler/images/

Kernel and initrd files are copied/symlinked here for usage by
koan.

## /var/www/cobbler/ks\_mirror/

Install trees are copied here.

## /var/www/cobbler/repo\_mirror/

Cobbler repo objects (i.e. yum, apt-mirror) are copied here.

## /var/lib/cobbler/

See individual descriptions of subdirectories below:

### /var/lib/cobbler/config/

Here cobbler stores configuration files that it creates when you
make or edit cobbler objects. If you are using serializer\_catalog
in modules.conf, these will exist in various ".d" directories under
this main directory.

### /var/lib/cobbler/backups/

This is a backup of the config directory created on RPM upgrades.
The configuration format is intended to be forward compatible (i.e.
upgrades without user intervention are supported) though this file
is kept around in case something goes wrong during an install
(though it never should, it never hurts to be safe).

### /var/lib/cobbler/kickstarts/

This is where cobbler's shipped kickstart templates are stored. You
may also keep yours here if you like. If you want to edit
kickstarts in the web application this is the recommended place for
them. Though other distributions may have templates that are not
explicitly 'kickstarts', we also keep them here.

### /var/lib/cobbler/snippets/

This is where cobbler keeps snippet files, which are pieces of text
that can be reused between multiple kickstarts.

### /var/lib/cobbler/triggers/

Various user-scripts to extend cobbler to perform certain actions
can be dropped into subdirectories of this directory. See
[CobblerTriggers](/cobbler/wiki/CobblerTriggers).

## /etc/

### /etc/cobbler/

  * cobbler.conf -- cobbler's most important config file. Self-explanatory with comments, in YAML format.
  * modules.conf --auxilliary config file. controls cobbler security, and whatDHCP/DNS engine is attached, see [Modules](Modules) for developer-level details, and also [Security Overview](Security Overview). Config Parser format.
  * users.digest -- if using the digest authorization
module, here's where your web app username/passwords live, see
[Cobbler Web Interface](Cobbler Web Interface) for more
info.

## /etc/cobbler/power

Here we keep the templates for the various power management modules
cobbler supports.

## /etc/cobbler/pxe

Various templates related to netboot installation, not neccessarily
"pxe".

## /etc/cobbler/zone\_templates

If the chosen DNS management module for DNS is BIND, this directory
is where templates for each zone file live. dnsmasq does not use
this directory.

## /etc/cobbler/reporting

Templates for various reporting related functions of cobbler, most
notably the new system email feature in Cobbler 1.5 and later.

## /usr/lib/pythonVERSION/site-packages/cobbler/

The source code to cobbler lives here.

## /usr/lib/pythonVERSION/site-packages/cobbler/modules/

This is a directory where modules can be dropped to extend cobbler
without modifying the core. See
[Modules](Modules).

