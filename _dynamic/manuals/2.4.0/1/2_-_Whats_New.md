---
layout: manpage
title: What's New
meta: 2.4.0
---

Cobbler 2.4.0 introduces many new features, as well as fixing several bugs from the 2.2.3 series.

## New Features
* {% linkup title:"Dynamic Settings" extrameta:2.4.0 %}, which allow settings for cobblerd to be modified on the fly without a restart of teh daemon.
* {% linkup title:"Distro Signatures" extrameta:2.4.0 %}, which will allow support for newer distro versions to be added without a complete Cobbler upgrade.
* {% linkup title:"Advanced Networking - Bonded Bridging" extrameta:2.4.0 %}
* Web GUI improvments, such as using tabs for each control category.
* koan additions:
    * Support for OpenVZ containers as a virtualization type.
    * Support for custom LVM logical volume names.
    * Support for qcow2/vmdk/raw image creation for virtualization files.
    * Added the --virt-pxe-boot option to force PXE booting of virtual guests.
* Better ubuntu support:
    * Support for precise and quantal.
    * New default preseed, with support for using snippets in the late/early commands.
* Many minor fixes and improvements:
    * Support for PEERDNS=no in ifcfg files (for RHEL and clones).
    * Support for standard format (YYYYMMDDXX) for bind zone files.
    * Puppet snippets/triggers use new puppet 3.0 cli syntax.
    * Support for LDAP client certificates.
    * Better template error logging.
    * Cobbler loaders are now hosted at http://cobbler.github.com/loaders.
    * New systemctl script.
* Experimental/tech previews:
    * Support for MySQL as a custom backend: {% linkup title:"Alternative Storage Backends - MySQL" extrameta:2.4.0 %}.

## Major Bug Fixes
* Reworked --available-as to use filter lists to limit file downloads.
* Tons of koan fixes, especially when using older versions of python-virtinst.
* Django 1.4 deprecation fixes.
