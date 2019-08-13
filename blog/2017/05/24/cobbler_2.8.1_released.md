---
layout: post
title:  "Cobbler 2.8.1 Released"
author: "Jörgen"
date:    2017-05-24 00:00 +0100
---

Cobbler 2.8.1 is now officially available, the first minor update in the 2.8.x series!

Feature improvements:

- Signature added for: sles 12sp2
- Signature added for: fedora 26
- Signature added for: ubuntu 17.04
- Signature added for: freebsd 10.3
- Signature added for: freebsd 11.0
- Signature added for: xen server 7.0
- Signature added for: xen server 7.1


Bugfixes:

- Cleanup distro_signatures
- Use <code>$bind_master</code> in <code>secondary.template</code> (#1720)
- Add <code>zonename</code> to metadata in <code>manage_bind</code> (#1700)
- Update cobbler.wsgi to Django >=1.4 API
- Add some input validation to repo configuration (#1741)
- Fix handling of multiple bridge interfaces (#1735)
- Added warnings in kickstart samples (#1737)
- Fix the auto-build when using autodiscovery (#1753)
- logrotate script is not compatible with systemd (#1745)
- Fixes to <code>setup.py</code> so that <code>python setup.py install</code> now works again on Debian/Ubuntu (#1750)
- Replication now works with Cobbler using non standard ports (#1637)
- Automatically restart <code>named-chroot</code> if needed
- Generalize names for named/dhcpd executables in cobbler check (#1672)
- No more manual symlinks required for Python dist-packages on Debian/Ubuntu (#1751)
- Code cleanup in <code>kickgen.py</code>, <code>setup.py</code>, etc
- Fixes to <code>cobbler.spec</code> for Fedora systems
- Fixes to several API calls relating to <code>mgmtclass</code>, <code>file</code> and <code>package</code>
- RHEL7 still needs to use the nameserver option
- Master interface now inherits MTU setting from slave interface
- Don't add multiple (bond) slave interfaces to <code>dhcpd.conf</code>
- Grub legacy loaders updated to the latest versions available
- Enable the source tree to be cloned on Windows systems (#1722)
- Minor SuSE AutoYast improvements


Sourcecode: <a href="https://github.com/cobbler/cobbler/releases/tag/v2.8.1">https://github.com/cobbler/cobbler/releases/tag/v2.8.1</a>
