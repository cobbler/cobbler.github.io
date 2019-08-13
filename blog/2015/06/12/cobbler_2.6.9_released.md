---
layout: post
title:  "Cobbler 2.6.9 Released"
author: "Jörgen"
date:    2015-06-12 00:00 +0100
---

Cobbler 2.6.9 is now officially available!

This release works around the DNS issues we are having with the cobblerd.org domain.
We have moved back to using hosted files on GitHub URLs.

If you are using online features like <code>get-loaders</code> and <code>signature update</code> you will have
to upgrade to this release!

Feature improvements:

- Add support for infiniband network interface type

Bugfixes:

- Fix problem in networking snippets related to per interface gateways
- Fix some issues in signaturs (duplicates, and re-add Fedora 21)

Sourcecode:

- <a href="https://github.com/cobbler/cobbler/releases/tag/v2.6.9">https://github.com/cobbler/cobbler/releases/tag/v2.6.9</a>

Packages will be provided as soon as possible, please check <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26">here</a>
