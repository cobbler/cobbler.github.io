---
layout: manpage
title: What's New
meta: 2.8.0
---

## 2.8.0

### New features / feature improvements

- Integrated pyflakes into the build system and resolved hundereds of issues
- Integrated pep8 (coding style) into the build system and resolved thousands of issues
- Add a new field to the system type: ipv6_prefix (\#203)
- Minor update to CSS; make better use of screen (tables) (cobbler-web)
- Add support for an empty system status
- If --dns-name is specified, set it as DHCP host-name in preference to the --hostname field
- Allow user to choose whether or not to delete item(s) recursively (cobbler-web)
- Set ksdevice kernel option to MAC address for ppc systems as bootif is not used by yaboot
- Return to list of snippets/kickstarts when snippet/kickstart is saved (cobbler-web)
- Layout in snippet/kickstart edit form has been improved (cobbler-web)
- Better handling of copy/remove actions for subprofiles (API and cobbler-web)
- Make kickstart selectable from a pulldown list in cobbler-web (\#991)

### Bugfixes

- Dont send the Puppet environment when system status is empty (\#560
- Cobbler-web kept only the most recent interface change (\#687)
- Fix broken gitdate, gitstamp values in /etc/cobbler/version
- Prevent disappearing profiles after cobblerd restart (\#1030)
- Add missing icons to cobbler_web/content (\#679)
- cobbler-ext-nodes was broken with mgmt_classes defined at the profile level (\#790)
- Properly name the VLAN interface in the manual page
- Fix wrong address of the Free Software Foundation
- Remove legacy (EL5/6) cruft from the RPM specfile
- Koan: use the print function instead of the print statement
- Minor improvement to LDAP configuration (\#217)
- Improvements to the unittest framework
- The user manual has been completely reviewed and lots of errors were fixed

### Upgrade notes

- The template_remote_kickstarts feature has been removed
- All object names are now validated like that of the system object
- The use of --parent and --distro on subprofiles are now mutually exclusive
- Support for s390/s390x has been removed
- Support for ia64 (Itanium) has been removed
- Support for the MySQL backend has been removed
- Support for deprecated fieldnames (subnet, bonding_master, bonding) has been removed
- Koan now requires python 2.6
- Red Hat specific kernel options have been removed from the settings file
- Deprecated Func integration: moved to contrib
- Deprecated Koan LiveCD: moved to contrib

