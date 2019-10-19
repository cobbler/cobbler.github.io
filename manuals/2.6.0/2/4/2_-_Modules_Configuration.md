---
layout: manpage
title: Modules Configuration
meta: 2.6.0
nav: Modules Configuration
navversion: nav26
---

Cobbler supports add-on modules, some of which can provide the same functionality (for instance, the 
authentication/authorization modules discussed in the
<a href="/manuals/2.6.0/5/2_-_Web_Authentication.html">Web Authentication</a> section). Modules of this nature are
configured via the `/etc/cobbler/modules.conf`-file, for example: `[dns]` chooses the DNS management engine if
`manage_dns` is enabled in `/etc/cobbler/settings`, which is off by default.

Choices:

- manage_bind    -- default, uses BIND/named
- manage_dnsmasq -- uses dnsmasq, also must select dnsmasq for dhcp below

````bash
[dns]
module = manage_bind
````

As you can see above, this file has a typical INI-style syntax where sections are denoted with the `[]` brackets and
entries are of the form `key = value`.

Many of these sections are covered in the
<a href="/manuals/2.6.0/3/4_-_Managing_Services_With_Cobbler.html">Managing Services With Cobbler</a> and 
<a href="/manuals/2.6.0/5/2_-_Web_Authentication.html">Web Authentication</a> topics later in this manual. Please refer
to those sections for further details on modifying this file.

As with the settings file, you must restart cobblerd after making changes to this file.
