---
layout: manpage
title: What's New
meta: 2.6.0
---


## 2.6.0

### Features

- We now build RPMs for RHEL/CentOS 6, Fedora 18/19/20, OpenSUSE 12.3/13.1/Factory
- Massive overhaul to python building & packaging infrastructure enabling alternate install prefix
- Initial support for Nexenta 4: distro import and manual PXE booting
- Added support for ESXi 6
- Improved support for running Cobbler inside a chroot() or container
- Added a config setting (always_write_dhcp_entries) to always write DHCP entries regardless of netboot setting

### Bugfixes

- Lots of code cleanup
- Minor improvements to the documentation

### Upgrade notes

- Support for python 2.4 (eg. RHEL5) has been dropped, we now require python 2.6+

