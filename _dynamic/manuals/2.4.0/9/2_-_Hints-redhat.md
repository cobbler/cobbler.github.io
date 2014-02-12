---
layout: manpage
title: Cobbler Manual
meta: 2.4.0
---
# Hints and tips: Redhat

A collection of tips for using Cobbler to deploy and support Redhat-based machines, including CentOS, Fedora, Scientific Linux, etc.

## rescue mode

Redhat-based systems offer a "rescue" mode, typically used for trying to analyse and recover after a major OS problem.  The usual way of doing this is booting from a DVD and selecting "rescue" mode at the relevant point.  But it is also possible to do this via Cobbler.  Indeed, if the machine lacks a DVD drive, alternatives such as this are vital for attempted rescue operations.

**RISK:**  _Because you are using this Cobbler deployment system that usually installs machines, there is the risk that this procedure could overwrite the very machine you are attempting to rescue.  So it is strongly recommended that, as part of your normal workflow, you develop and periodically verify this procedure in a safe, non-production, non-emergency environment._

The example below illustrates RHEL 5.6.  The detail may vary for other Redhat-like flavours.

### Assumptions

* Your target machine's Cobbler network deployment is supported by exactly one active DHCP server.
* Your deployed machines are already present in Cobbler for their earlier deployment purposes.
* A deployed machine's `kopts` setting field is usually null.
* A deployed machine's `netboot-enabled` setting is false outside deployment time.

### Procedure

As stated above: _verify this periodically, outside emergency times, in a non-production environment._

On the Cobbler server:

    cobbler system edit --name=sick-machine --kopts='rescue'
    cobbler system edit --name=sick-machine --netboot-enabled=true
    cobbler sync

As always, don't forget that "cobbler sync".

At the client "sick-machine", start a normal deployment-style network boot.  During this you should eventually see:

* Usual blue screen: `Loading SCSI driver`.  There may be a couple of similar screens.
* Usual blue screen: `Sending request for IP information for eth0...`.  (The exact value of that "eth0" is dependent on your machine.)
* Usual blue screen: repeat `Sending request for IP...` , but this time the header bar at the top should have `Rescue Mode` appended.
* Usual back-to-black: `running anaconda` and a couple of related lines.
* Blue screen with header bar `Rescue` and options "Continue", "Read-Only", "Skip".

In particular, if the second `Sending request for IP...` screen fails to say `Rescue Mode`, it is strongly recommended that you immediately abort the process to avoid the risk of overwriting the machine.

At this point you select whichever option is appropriate for your rescue and follow the Redhat rescue procedures.  (The detail is independent of, and beyond the scope of, this Cobbler procedure.)

When you have finished, on the Cobbler server nullify the rescue:

    cobbler system edit --name=sick-machine --kopts=''
    cobbler system edit --name=sick-machine --netboot-enabled=false
    cobbler sync
