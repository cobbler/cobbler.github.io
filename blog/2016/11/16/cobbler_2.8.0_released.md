---
layout: post
title:  "Cobbler 2.8.0 Released"
author: "Jörgen"
date:    2016-11-16 00:00 +0100
---

Cobbler 2.8.0 is now officially available!

Deprecation warnings:

The following list of features have been deprecated and will <em>not</em> be available in Cobbler 3.0. Users depending
on one of these features should stick to the 2.8.x (LTS) series. If you'd like to maintain one of these features in 3.x
and beyond, then please reach out to the developers through GitHub or the mailinglist.

- MySQL backend
- CouchDB backend
- MongoDB backend
- Monit support
- Platforms: s390/s390x and ia64
- System field names: subnet, bonding_master, bonding
- Func integration
- Koan LiveCD
- Koan LDAP configuration
- redhat_management (Spacewalk/Satellite)
- Remote kickstart files/templates (other than on the Cobbler server)
- The concurrent use of <code>parent</code> and <code>distro</code> on subprofiles

Feature improvements:

- Signature updates: Fedora 24/25, Ubuntu 16.10, Virtuozzo 7
- Integrated <code>pyflakes</code> into the build system and fixed all reported issues
- Integrated Travis CI into the build system (<code>make qa</code>)
- Allow https method in repo management (#1587)
- Add support for the <code>ppc64le</code> architecture
- Backport gpxe mac search argument
- Added support for fixed DHCP IPs when using vlan over bond
- Add support for Django 1.7.x and 1.8.x
- Add action name to cobbler action <code>--help</code> output

Bugfixes:

- Added HOSTS_ALLOW acl in settings.py (CVE-2016-9014)
- Profile template logic seperated for grub and pxelinux formats
- Refer to system_name in grubsystem.template
- Add netmask and dhcp_tag to slave interfaces in ISC DHCP
- Koan now works with CentOS version numbers
- Fixes to pxesystem_esxi.template
- Move <code>get-loaders</code> to https transport
- Add default/timeout to grubsystem.template
- Anamon now actually waits on files that you specify with <code>--watchfiles</code>
- Do not set interface["filename"] to /pxelinux.0 in manage_isc.py (#1565)
- Allow the use of relative paths when importing a distro (#1613)
- Fix /etc/xinetd.d/rsync check (#1651)
- Exit with a appropiate message when signature file can't be parsed
- Handle cases where virt-install responds to <code>--version</code> on stderr (Koan)
- Fix mangling of kernel options in  edit profile command with <code>--in-place</code>
- Several fixes to Koan regarding os-info-query and os-variants

Sourcecode: <a href="https://github.com/cobbler/cobbler/releases/tag/v2.8.0">https://github.com/cobbler/cobbler/releases/tag/v2.8.0</a>

Packages will be provided as soon as possible, please check <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler28">here</a>
