---
layout: post
title:  "Cobbler 2.8.4 Released"
author: "Jörgen"
date:    2018-11-23 00:00 +0100
---

New features:

- manage_bind can now manage ipmi A records, if power_address is an IP
- managing /etc/genders for use with parallel shells like pdsh
- support for ESXi 6.7

Feature improvements:

- If a per-interface gateway is set, use that in the DHCP configuration
- When reposyncing, ignore the default repo config directory
- Fix cobbler sync when using multiple bonded interfaces

Security:

- CVE-2018-10931 - forbid exposure of private methods in the API
- Protect modify_setting API

Sourcecode: <a href="https://github.com/cobbler/cobbler/releases/tag/v2.8.4">https://github.com/cobbler/cobbler/releases/tag/v2.8.4</a>
