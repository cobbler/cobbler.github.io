---
layout: manpage
title: What's New
meta: 2.6.0
---

## 2.6.6

### Feature improvements

- Add proxy support for get-loaders, signature update and reposync (\#1286)
- Enable external YUM repo mirroring through a proxy server
- Update yaboot to 1.3.17
- Support virtio26 for generic qemu fallback (Koan)

### Bugfixes

- Changed Apache configuration directory in Ubuntu 14.04 (\#1208)
- Add proxy support for get-loaders, signature update and reposync (\#1286)
- Creating RPMs is done with make rpms (\#1268)
- Post install report mails are not mailed when ignorelist is empty (\#1248)
- Regression: kickstart edit in cobbler-web fixed
- Regression: kickstart filepath validation
- Make <<inherit>> a valid kickstart location
- Blacklist gpgkey as an invalid option to the repo statement
- gpgcheck / enabled are not valid in kickstart, only in config.repo
- Updated man page to reflect the removal of URL support for kickstarts
- Regression: <<inherit>> was not available as kickstart value
- Return right value from TftpdPyManager.what method
- Fixed a typo in the power management API
- Ensure all variables are available in PXE generation (\#505)
- Dont reset CONFIG_ARGS as it might have been sourced from sysconfig/defaults (\#1141)

### Upgrade notes

None.


## 2.6.5

### Feature improvements

None.

### Bugfixes

- Add missing _validate_ks_template_path function so that
kickstarts for systems can now be changed again (\#1156)
- Remove root= argument from boot when using grubby and
replace-self to avoid booting the currently running OS (\#638)

### Upgrade notes

None.

## 2.6.4

### Feature improvements

- Make kickstart selectable from a pulldown list in cobbler-web (\#991)
- Minor adjustment to the error_page template (cobbler-web)
- Minor improvements to edit snippets/kickstarts template (cobbler-web)
- Allow for empty system status

### Bugfixes

- Exit with an error if cobblerd executable can't be found (\#1108 \#1135)
- Fix cobbler sync bug through xmlrpc api (NoneType object has no attribute info)
- Changes (edit/add) to multiple interfaces in cobbler-web now actually work (\#687)
- Don't send the Puppet environment when system status is empty (\#560)
- Add strict kickstart check in the API (again for \#939)
- Do not allow kickstarts in /etc/cobbler
- Fix broken gitdate, gitstamp values in version file (cobbler version)
- Prevent disappearing profiles after cobblerd restart (\#1030)

### Upgrade notes

This release makes the use of --parent and --distro mutually exclusive.
The consequence is that subprofiles always have the same distro as
the parent profile. This has been the intended behaviour ever since
subprofiles got introduced.

Please check if you have subprofiles with different distros than the
parent profile and reconsider and adjust your configuration.


## 2.6.3

### Feature improvements

- Add a new field to the system type: ipv6_prefix (\#203)
- Return to kickstart/snippet list after save (cobbler-web)

### Bugfixes

- Restrict kickstart/snippet paths to /var/lib/cobbler/ (\#939 and CVE-2014-3225)
- Several improvements to the RPM specfile
- Add missing icons to cobbler-web (\#679)
- cobbler-ext-nodes was broken with mgmt_classes defined at the profile level (\#790)
- Properly name the VLAN interface in the cobbler manpage
- Fix wrong address of the Free Software Foundation in source headers


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

