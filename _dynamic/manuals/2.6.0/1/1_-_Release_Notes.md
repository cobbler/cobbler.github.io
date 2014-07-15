---
layout: manpage
title: What's New
meta: 2.6.0
---

## 2.6.2

### Feature improvements

- Add EL7 (RHEL/CentOS) to distro signatures
- Add CloudLinux6 support to distro signatures
- Minor update to CSS; make better use of screen (tables)
- Make Cobbler work on EL7 (RHEL/CentOS)

### Bugfixes

- pre_install_network_config: only use slaves with a valid MAC address
- Remove colon from VLAN regex pattern
- Improve exception logging in BootCLI (Issue 148)
- Item.set_name optimizations
- Minor improvement to LDAP configuration (Issue 217)
- Fixes to Makefile (Issue 555)

## 2.6.1

### Feature improvements

- Add a distro_signature for Ubuntu 14.04
- Improve performance of the "cobbler sync" operation
- Provide Debian and Ubuntu packages on the openSUSE build service
- Add support for a wget repo breed
- Cobbler and koan are now seperated debian packages

### Bugfixes

- Improve support for running inside chroot() and/or containers
- Added missing docs to the RPM packages
- Improved virt-install detection on non-rpm distros
- Several fixes for running Cobbler on Debian like systems
- Fixed typos in default kickstart files

## 2.6.0

This release cycle was primarily aimed at providing our software directly to our users.
A substantial overhaul of our building & packaging infrastructure allows us to provide packages and repositories for:
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/CentOS_CentOS-6/">CentOS 6</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/RedHat_RHEL-6/">RHEL 6</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/Fedora_18/">Fedora 18</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/Fedora_19/">Fedora 19</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/Fedora_20/">Fedora 20</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/openSUSE_12.3/">openSUSE 12.3</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/openSUSE_13.1/">openSUSE 13.1</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/openSUSE_Factory/">openSUSE Factory</a>

### Features

- Initial support for Nexenta 4: distro import and manual PXE booting
- Added support for ESXi 6
- Improved support for running Cobbler inside a chroot() or container
- Added a config setting (always_write_dhcp_entries) to always write DHCP entries regardless of netboot setting

### Bugfixes

- Lots of code cleanup & bugfixes
- Minor improvements to the documentation

### Upgrade notes

- Support for python 2.4 (eg. RHEL5) has been dropped, we now require python 2.6+

