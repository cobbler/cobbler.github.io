---
layout: post
title:  "Cobbler 2.6.11 Released"
author: "Jörgen"
date:    2016-01-23 00:00 +0100
---

Cobbler 2.6.11 is now officially available!

Feature improvements:

- Add support for FreeBSD 9.1, 9.2, 9.3, 10.1 and 10.2 in signatures
- Add support for SLES 12.1 in signatures
- Koan: use new dracut ip option for configuring static interfaces

Bugfixes:

- Improve handling of yum-utils/dnf, rsync in <code>cobbler check</code> and RPM packaging
- Change online Cobbler resource URL's from cobbler.github.com to cobbler.github.io
- Fix bonding for RHEL 6 and RHEL 7
- Koan: fix incompatibility with F21 virt-install
- Koan: fix os_version conditionals

Sourcecode: <a href="https://github.com/cobbler/cobbler/releases/tag/v2.6.11">https://github.com/cobbler/cobbler/releases/tag/v2.6.11</a>

Packages will be provided as soon as possible, please check <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26">here</a>