---
layout: manpage
title: Cobbler Sync
meta: 2.6.0
---

The sync command is very important, though very often unnecessary for most situations. It's primary purpose is to force
a rewrite of all configuration files, distribution files in the TFTP root, and to restart managed services. So why is it
unnecessary? Because in most common situations (after an object is edited, for example), Cobbler executes what is known
as a "lite sync" which rewrites most critical files.

When is a full sync required? When you are using manage_dhcpd
([Managing DHCP]({% link manuals/2.6.0/3/4/1_-_Managing_DHCP.md %})) with systems that use static leases. In that
case, a full sync is required to rewrite the `dhcpd.conf` file and to restart the dhcpd service. Adding support for
OMAPI is on the roadmap, which will hopefully relegate full syncs to troubleshooting situations.

**Example:** `$ cobbler sync`

### How Sync Works

A full sync will perform the following actions:

1. Run pre-sync [Triggers]({% link manuals/2.6.0/4/4/1_-_Triggers.md %})
2. Clean the TFTP tree of any and all files
3. Re-copy boot loaders to the TFTP tree
4. Re-copy distribution files to the TFTP tree
    - This will attempt to hardlink files if possible
5. Rewrite the pxelinux.cfg/default file
6. Rewrite all other pxelinux.cfg files for systems
7. Rewrite all managed config files (DHCP, DNS, etc.) and restarts services
8. Cleans the "link cache"
9. Executes post-sync and change [Triggers]({% link manuals/2.6.0/4/4/1_-_Triggers.md %})

As noted above, this can take quite a bit of time if there are many distributions.

**See also:**

- [Managing Services With Cobbler]({% link manuals/2.6.0/3/4_-_Managing_Services_With_Cobbler.md %})
