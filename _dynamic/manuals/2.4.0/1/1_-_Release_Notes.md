---
layout: manpage
title: What's New
meta: 2.4.0
---

## 2.4.6

### Feature improvements

- Improved the form for editing snippets/kickstarts (cobbler-web)
- Minor update to CSS; make better use of screen (tables) (cobbler-web)
- Add a new field to the system type: ipv6_prefix (\#203)

### Bugfixes

- Restrict kickstart/snippet paths to /var/lib/cobbler/ (\#939 and CVE-2014-3225)
- Several improvements to the RPM specfile (redhat bugzilla \#838884)
- Add missing icons to cobbler-web (\#679)
- cobbler-ext-nodes was broken with mgmt_classes defined at the profile level (\#790)
- Properly name the VLAN interface in the cobbler manpage
- Fix wrong address of the Free Software Foundation in source headers

### Upgrade notes

None.


## 2.4.5

### Feature improvements

- Add support for importing Enterprise Linux 7 (RHEL/CentOS)
- Add support for importing CloudLinux 6

### Bugfixes

- Minor improvement to LDAPS configuration (\#217)
- pre_install_network_config snippet: only use slaves with a valid MAC address
- remove colon from VLAN regex pattern

### Upgrade notes

None.


## 2.4.4

### Feature improvements

- Add a distro_signature for Ubuntu 14.04
- Add an option to always write DHCP entries regardless of netboot setting
- Improve support for running inside chroot() and/or containers
- Improve performance of the "cobbler sync" operation

### Bugfixes

- Fix infinite loop in get_file_device_path() in chroot environment
- Fixed an Exception in Koans get_insert_script() function

### Upgrade notes

None.


## 2.4.3

### Feature improvements

- Improve support for ESXi when using updated sources
- Add support for SLES 12 to distro_signatures
- Add support for Oracle Enterprise Linux to distro_signatures

### Bugfixes

- Manual page correction regarding the use of the --server parameter
- Minor corrections to the build MANIFEST
- Fix a SyntaxError in Koan / OVZ install

### Upgrade notes

None.


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

- {% linkup title:"Dynamic Settings" extrameta:2.4.0 %}, which allow settings for cobblerd to be modified on the fly without a restart of teh daemon.
- {% linkup title:"Distro Signatures" extrameta:2.4.0 %}, which will allow support for newer distro versions to be added without a complete Cobbler upgrade.
- {% linkup title:"Advanced Networking - Bonded Bridging" extrameta:2.4.0 %}
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
    * Support for MySQL as a custom backend: {% linkup title:"Alternative Storage Backends - MySQL" extrameta:2.4.0 %}.

### Bugfixes

- Reworked --available-as to use filter lists to limit file downloads.
- Tons of koan fixes, especially when using older versions of python-virtinst.
- Django 1.4 deprecation fixes.

### Upgrade notes

Some fields on system objects have been renamed to accomodate support for bridged interfaces:

- subnet => netmask
- bond_master => interface_master
- bond => interface_type

Cobbler has code to assist in the migration to the new field names but you must save all system objects to trigger the rename.
You can use the following script to automate that process:

    #!/usr/bin/python
    import xmlrpclib

    remote= xmlrpclib.Server("http://localhost/cobbler_api")
    token = remote.login("testing","testing")
    all_systems = remote.find_system()
    for system in all_systems:
        system_id = remote.get_system_handle(system, token)
        remote.save_system(system_id, token)


Kickstart start/done migrated to snippets:

- $kickstart_start => $SNIPPET('kickstart_start')
- $kickstart_done => $SNIPPET('kickstart_done')
