---
layout: manpage
title: Build ISO
meta: 2.2.3
---
# {{ page.title }}

Often an environment cannot support PXE because of either (A) an
unfortunate lack of control over DHCP configurations (i.e. another
group owns DHCP and won't give you a next-server entry), or (B) you
are using static IPs only.

This is easily solved:

    # cobbler buildiso

What this command does is to copy all distro kernel/initrds onto a
boot CD image and generate a menu for the ISO that is essentially
equivalent to the PXE menu provided to net-installing machines via
Cobbler.

By default, the boot CD menu will include all profiles and systems,
you can force it to display a list of profiles/systems in concern
with the following.

Cobbler versions >= 2.2.0:

    # cobbler buildiso --systems="system1 system2 system3"
    # cobbler buildiso --profiles="profile1 profile2 profile3"

Cobbler versions < 2.2.0:

    # cobbler buildiso --systems="system1,system2,system3"
    # cobbler buildiso --profiles="profile1,profile2,profile3"

If you need to install into a lab (or other environment) that does not have network
access to the cobbler server, you can also copy a full distribution tree plus profile
and system records onto a disk image:

    # cobbler buildiso --standalone --distro="distro1"

