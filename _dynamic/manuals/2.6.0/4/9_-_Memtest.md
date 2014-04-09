---
layout: manpage
title: Cobbler Manual
meta: 2.6.0
---
## Memtest

If installed, cobbler will put an entry into all of your PXE menus
allowing you to run memtest on physical systems without making
changes in Cobbler. This can be handy for some simple diagnostics.

Steps to get memtest to show up in your PXE menus:

    # yum install memtest86+
    # cobbler image add --name=memtest86+ --file=/path/to/memtest86+ --image-type=direct
    # cobbler sync

memtest will appear at the bottom of your menus after all of the
profiles.

## Targeted Memtesting

However, if you already have a cobbler system record for the
system, you can't get the menu. No problem!

    cobbler image add --name=foo --file=/path/to/memtest86 --image-type=direct
    
    cobbler system edit --name=bar --mac=AA:BB:CC:DD:EE:FF --image=foo --netboot-enabled=1

The system will boot to memtest until you put it back to it's
original profile.

CAUTION!

When restoring the system back from memtest, make sure you turn
it's netboot flag /off/ if you have it set to PXE first in the BIOS
order, unless you want to reinstall the system!

    cobbler system edit --name=bar --profile=old_profile_name --netboot-enabled=0

Naturally if you /do/ want to reinstall it after running memtest,
just use --netboot-enabled=1

If you are curious about the image objects and what they do (and
don't do) read [AllAboutImages](/cobbler/wiki/AllAboutImages).

