---
layout: manpage
title: What's New
meta: 2.6.0
---

## 2.4.2

### Feature improvements

- Added support for SLES10 to distro_signatures

### Bugfixes

- Fix distro detection on RHEL & SuSE systems
- Corrected AutoYaST generation when scripts are included
- Fix elilo and yaboot filenames in dhcp configuration

### Upgrade notes

None.

## 2.4.1

### Feature improvements

- Many distro_signatures updates
- Anamon logfile support has been extended
- Allow the use of systems without associated kickstart
- Koan now supports the qed disk driver
- Automatic cobbler_web restart after cobblerd restart
- Improved Puppet certificate management
- Cobbler replication now supports ssl
- Koan gained support for --proxy & --server options
- Xen guest provisioning in koan
- Added a Cobbler post install report ignorelist
- Authentication token expiration time is now configurable
- Autentication passthru is now again functional
- SELinux detection in koan

### Bugfixes

- Improved logging and exception handling in many places
- Several fixes for running Cobbler on OpenSUSE and SLES
- Better proxy handling in buildiso
- Concurrency/locking improvements
- Removed some hardcoded paths, making life easier for downstream packagers
- Add missing (sub)commands to the CLI
- Several Makefile fixes
- Small improvements to cobbler-web
- Many fixes to koan
- Several WSGI related improvements
- Many more...

### Upgrade notes

None.

## 2.4.0

## Features

- {% linkup title:"Dynamic Settings" extrameta:2.6.0 %}, which allow settings for cobblerd to be modified on the fly without a restart of teh daemon.
- {% linkup title:"Distro Signatures" extrameta:2.6.0 %}, which will allow support for newer distro versions to be added without a complete Cobbler upgrade.
- {% linkup title:"Advanced Networking - Bonded Bridging" extrameta:2.6.0 %}
- Web GUI improvments, such as using tabs for each control category.
- koan additions:
    * Support for OpenVZ containers as a virtualization type.
    * Support for custom LVM logical volume names.
    * Support for qcow2/vmdk/raw image creation for virtualization files.
    * Added the --virt-pxe-boot option to force PXE booting of virtual guests.
- Better ubuntu support:
    * Support for precise and quantal.
    * New default preseed, with support for using snippets in the late/early commands.
- Many minor fixes and improvements:
    * Support for PEERDNS=no in ifcfg files (for RHEL and clones).
    * Support for standard format (YYYYMMDDXX) for bind zone files.
    * Puppet snippets/triggers use new puppet 3.0 cli syntax.
    * Support for LDAP client certificates.
    * Better template error logging.
    * Cobbler loaders are now hosted at http://cobbler.github.com/loaders.
    * New systemctl script.
- Experimental/tech previews:
    * Support for MySQL as a custom backend: {% linkup title:"Alternative Storage Backends - MySQL" extrameta:2.6.0 %}.

### Bugfixes

- Reworked --available-as to use filter lists to limit file downloads.
- Tons of koan fixes, especially when using older versions of python-virtinst.
- Django 1.4 deprecation fixes.

### Upgrade notes

None.
