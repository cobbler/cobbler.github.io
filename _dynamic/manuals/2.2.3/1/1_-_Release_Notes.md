---
layout: manpage
title: Release Notes
meta: 2.2.3
---

## 2.2.3

### Features

### Bugfixes

### Upgrade notes

None.

## 2.2.2

### Features

- Initial support for configurable on-disk format on virtual disks
- Add support for Fedora16, rawhide, OpenSuSE 11.x and 12.1
- Several small webui improvements

### Bugfixes

- Serveral webui fixes
- Overriding nameservers via kopts in buildiso now works
- Images without distro caused a stack dump in pxegen
- Code cleanup and improvements in distro importers
- Code cleanup sub_process handling
- Old import modules are removed
- Duplicate kopts in buildiso are now supported
- Several bugfixes to koan

### Upgrade notes

None

## 2.2.1

### Features

- Add support for systemd in the Cobbler spec file

### Bugfixes

None.

### Upgrade notes

None.

## 2.2.0

### Features

- Ubuntu and Debian support again!
- Support for SuSE
- Support for FreeBSD
- Support for ESX 4+/ESXi
- Integration with the python TFTP server (pytftpd)
- "fetchable files" and "boot files" support for distros that need to get more files from the TFTP server
- Faster sync using link cache
- Support for EFI grub booting
- Support for bridged interfaces
- WSGI instead of mod_python for the web interface.
- Lots of Web UI improvements
- MongoDB backend support

### Bugfixes

Seriously way too many to list individually. Read the change log, there were almost 1000 commits since the last release!

### Upgrade notes

Before upgrading be sure to make a backup of /etc/cobbler and /var/lib/cobbler, this is where all your data resides. As some things have changed, read these notes before you get into reading about all the new features.

- Review/modify the /etc/cobbler/modules.conf.rpmnew file to include your site specific settings. Then move the new file into place.
- Review/modify the /etc/httpd/conf.d/cobbler_web.conf.rpmnew file and move it into place.
- Remove mod_python and install the mod_wsgi package
- Uncomment the LoadModule command in /etc/httpd/conf.d/wsgi.conf
- Change `$kickstart_start` / `$kickstart_done` to `$SNIPPET('kickstart_start')` / `$SNIPPET('kickstart_done')` in the default kickstart template.
- The buildiso subcommand now wants a space (instead of a comma) delimited list (eg. cobbler buildiso --systems="sys1 sys2 sys3")

Internal changes:
- The "subnet" field has been renamed to "netmask". You might want to review your kickstarts/templates
- The "bonding" & "bond_master" interface types are deprecated and replaced by new fields: "interface_type" & "interface_master"

By loading and saving system objects any old fields/values will be translated to the new fields/values.
As always, if you have any questions, please feel free to ask the mailing list or hop on #cobbler on irc.freenode.net -- that's what we are there for! 

