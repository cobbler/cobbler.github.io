---
layout: manpage
title: What's New
meta: 2.8.0
---

## 2.8.0

### Deprecation warnings

The following list of features have been deprecated and will *not* be available in Cobbler 3.0. Users depending on one of these features should stick to the 2.8.x (LTS) series. If you'd like to maintain one of these features in 3.x and beyond, then please reach out to the developers through GitHub or the mailinglist.

- MySQL backend
- CouchDB backend
- Monit support
- Platforms: s390/s390x and ia64
- Field names: subnet, bonding_master, bonding
- Func integration
- Koan LiveCD
- Koan LDAP configuration
- redhat_management (Spacewalk/Satellite)
- Remote kickstart files/tempaltes (other than on the Cobbler server)
- The concurrent use of ``parent`` and ``distro`` on subprofiles
- Support for Python 2.6.x based systems

### Feature improvements

- Integrated ``pyflakes`` into the build system and fixed all reported issues
- Add support for SLES12 SP1 to the signatures (\#1597)
- Add support for FreeBSD 9.1, 9.2, 9.3, 10.1 and 10.2
-

### Bugfixes

- Allow the use of relative paths when importing a distro (\#1613)
- Improve handling of yum-utils/dnf, rsync in `cobbler check` and RPM packaging (\#1611, \#1586, \#1543, \#1427, \#791)
-

