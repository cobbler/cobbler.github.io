---
layout: post
title:  "Cobbler 2.6.6 Released"
author: "Jörgen"
date:    2014-10-19 00:00 +0100
---

Cobbler 2.6.6 is now officially available!

Feature improvements:

- Add proxy support for get-loaders, signature update and reposync (#1286)
- Update yaboot to 1.3.17
- Support virtio26 for generic qemu fallback (Koan)

Bugfixes:

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

Sourcecode:

- <a href="https://github.com/cobbler/cobbler/releases/tag/v2.6.6">https://github.com/cobbler/cobbler/releases/tag/v2.6.6</a>

<p>Packages:</p>

- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/CentOS_CentOS-6/">CentOS 6</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/CentOS_CentOS-7/">CentOS 7</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/RedHat_RHEL-6/">RHEL 6</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/RedHat_RHEL-7/">RHEL 7</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/Fedora_18/">Fedora 18</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/Fedora_19/">Fedora 19</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/Fedora_20/">Fedora 20</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/openSUSE_12.3/">openSUSE 12.3</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/openSUSE_13.1/">openSUSE 13.1</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/openSUSE_Factory/">openSUSE Factory</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/Debian_7.0/">Debian 7</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/xUbuntu_12.04/">Ubuntu 12.04</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/xUbuntu_12.10/">Ubuntu 12.10</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/xUbuntu_13.10/">Ubuntu 13.10</a>
- <a href="http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/xUbuntu_14.04/">Ubuntu 14.04</a>

