---
layout: manpage
title: 1 - Release Notes
meta: 2.6.0
---

## 2.6.11

### Feature improvements

- Add support for FreeBSD 9.1, 9.2, 9.3, 10.1 and 10.2
- Add support for SLES 12.1 in signatures (#1597)
- Koan: use new dracut ip option for configuring static interfaces


### Bugfixes

- Improve handling of yum-utils/dnf, rsync in <code>cobbler check</code> and RPM packaging (#1611, #1586, #1543, #1427, #791)
- Change online Cobbler resource URL's from cobbler.github.com to cobbler.github.io
- Fix bonding for RHEL 6 and RHEL 7
- Koan: fix incompatibility with F21 virt-install (#1398)
- Koan: fix os_version conditionals

## 2.6.10

### Feature improvements

- Use DNF when available (available on Fedora 22+)
- Add Fedora 22 to signatures
- Add Fedora 23 to signatures
- Add openSUSE 13.2 to signatures
- Add Debian Stretch (testing) to signatures
- Add XenServer 6.5.0 to signatures

### Bugfixes

- Do not install distro_signatures.json in /etc/cobbler

## 2.6.9

This release works around the DNS issues we are having with the cobblerd.org domain. We have moved back to using hosted
files on GitHub URLs.

If you are using online features like <code>get-loaders</code> and <code>signature update</code> you will have
to upgrade to this release!

### Feature improvements

- Add support for infiniband network interface type

### Bufixes

- Fix problem in networking snippets related to per interface gateways
- Fix some issues in signaturs (duplicates, and re-add Fedora 21)

## 2.6.8

### Feature improvements

- Add distro signature for SLES11sp4 (#1402)
- Add distro signature for Debian 8.0.0
- Add distro signature for Ubuntu 15.04
- Add distro signature for FreeBSD 10.0
- Add distro signature for Fedora 21
- Several improvements to the Makefile
- Handle per interface gateway in pre_install_network_config
- Add gPXE template support for the windows breed

### Bugfixes

- Fix cobbler check on EL7 (#1396)
- Remove installer_templates from RPM specfile
- Remove duplicate entries from RPM specfile
- Fix make webtest on Ubuntu 14.04.2 (#1417)
- Remove __sorter() from XMLRPC API
- Fixes to Debian/Ubuntu packaging of /var/lib/cobbler/ content
- Fix version comparison for python-virt double digits
- The virt_disk_driver field is now a list
- Fields in item_system now properly inherit from item_profile when present
- Handle chowning repos for debians default apache group
- elilo-ia64.efi is added to the loaders (#1385)
- Fix Ubuntu/Debian permission errors in cobbler-web
- Don't write hwaddress when the macaddress is empty (#1322)
- Fix createrepo version comparison (#1453)

## 2.6.7

### Feature improvements

- Use curl by default on RPM based systems instead of wget
- Add support for inst.stage2 install tree location to Koan

Bugfixes

- Add missing self.logger to util.die() calls (#1326)
- Add default values for proxy_url_ext and proxy_url_int to settings.py (unbreak upgrades)
- With mirror_locally false yum_sync now writes the .repo file again
- Don't write exclude= twice to .repo files
- Map exclude/include properly to repo lines

## 2.6.6

### Feature improvements

- Add proxy support for get-loaders, signature update and reposync (#1286)
- Update yaboot to 1.3.17
- Support virtio26 for generic qemu fallback (Koan)

### Bugfixes

- Changed Apache configuration directory in Ubuntu 14.04 (#1208)
- Creating RPMs is done with make rpms (#1268)
- Post install report mails are not mailed when ignorelist is empty (#1248)
- Regression: kickstart edit in cobbler-web fixed
- Regression: kickstart filepath validation
- Blacklist gpgkey as an invalid option to the repo statement
- gpgcheck / enabled are not valid in kickstart, only in config.repo
- Updated man page to reflect the removal of URL support for kickstarts
- Regression: inherit was not available as kickstart value
- Return right value from TftpdPyManager.what method
- Fixed a typo in the power management API
- Ensure all variables are available in PXE generation (#505)
- Dont reset CONFIG_ARGS as it might have been sourced from sysconfig/defaults (#1141)

### Upgrade notes

None.

## 2.6.5

### Feature improvements

None.

### Bugfixes

- Add missing _validate_ks_template_path function so that kickstarts for systems can now be changed again (#1156)
- Remove root= argument from boot when using grubby and replace-self to avoid booting the currently running OS (#638)

## Upgrade notes

None.

## 2.6.4

### Feature improvements

- Make kickstart selectable from a pulldown list in cobbler-web (#991)
- Minor adjustment to the error_page template (cobbler-web)
- Minor improvements to edit snippets/kickstarts template (cobbler-web)
- Allow for empty system status

### Bugfixes

- Exit with an error if cobblerd executable can't be found (#1108 #1135)
- Fix cobbler sync bug through xmlrpc api (NoneType object has no attribute info)
- Changes (edit/add) to multiple interfaces in cobbler-web now actually work (#687)
- Don't send the Puppet environment when system status is empty (#560)
- Add strict kickstart check in the API (again for #939)
- Do not allow kickstarts in /etc/cobbler
- Fix broken gitdate, gitstamp values in version file (cobbler version)
- Prevent disappearing profiles after cobblerd restart (#1030)

### Upgrade notes

This release makes the use of --parent and --distro mutually exclusive. The consequence is that subprofiles always have
the same distro as the parent profile. This has been the intended behaviour ever since subprofiles got introduced.

Please check if you have subprofiles with different distros than the parent profile and reconsider and adjust your configuration.

## 2.6.3

### Feature improvements

- Add a new field to the system type: ipv6_prefix (#203)
- Return to kickstart/snippet list after save (cobbler-web)

### Bugfixes

- Restrict kickstart/snippet paths to /var/lib/cobbler/ (#939 and CVE-2014-3225)
- Several improvements to the RPM specfile
- Add missing icons to cobbler-web (#679)
- cobbler-ext-nodes was broken with mgmt_classes defined at the profile level (#790)
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
A substantial overhaul of our building &amp; packaging infrastructure allows us to provide packages and repositories for:

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

- Lots of code cleanup &amp; bugfixes
- Minor improvements to the documentation

### Upgrade notes

- Support for python 2.4 (eg. RHEL5) has been dropped, we now require python 2.6+

