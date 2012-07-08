---
layout: manpage
title: Replicate
meta: 2.2.3
---
# {{ page.title }}

    cobbler replicate --help

Replication works by downloading the configuration from one cobbler
server into another. It is useful for Highly Available setups,
disaster recovery, support of multiple geographies, or for load
balancing.

    cobbler replicate --master=master.example.org

With the default arguments, only distribution and profile metadata
are synchronized. Without any of the other sync flags (described
below) it is assumed data backing these objects (such as
kernels/initrds, etc) are already accessible. Don't worry though,
cobbler can help move those over too.

## Transferring More Than Just Metadata

Cobbler can transfer mirrored trees, packages, snippets, kickstart
templates, and triggers as well. To do this, just use the
appropriate flags with cobbler replicate.

    [root@localhost mdehaan]# cobbler replicate --help
    Usage: cobbler [options]
    
    Options:
      -h, --help            show this help message and exit
      --master=MASTER       Cobbler server to replicate from.
      --distros=PATTERN     pattern of distros  to replicate
      --profiles=PATTERN    pattern of profiles to replicate
      --systems=PATTERN     pattern of systems to replicate
      --repos=PATTERN       pattern of repos to replicate
      --image=PATTERN       pattern of images to replicate
      --omit-data           do not rsync data
      --prune               remove objects (of all types) not found on the master

## Setup

On each replica-to-be cobbler server, just install cobbler as
normal, and make sure /etc/cobbler/settings and
/etc/cobbler/modules.conf are appropriate. Use "cobbler check" to
spot check your work. Cobbler replicate will not configure these
files, and you may want different site-specific settings for
variables in these files. That's fine, as cobbler replicate will
respect these.

## How It Works

Metadata is transferred over Cobbler XMLRPC, so you'll need to have
the Cobbler XMLRPC endpoint accessible --
[http://servername:80/cobbler\_api](http://servername:80/cobbler_api).
This is the read only API so no authentication is required. This is
possible because this is a user-initiated pull operation, not a
push operation.

Files are transferred either by rsync (over ssh) or scp, so you
will probably want to use ssh-agent prior to kicking off the
replicate command, or otherwise use authorized\_keys on the remote
host to save typing.

## Limitations

It is perfectly fine to sync data bi-directionally, though keep in
mind metadata being synced is not timestamped with the time of the
last edit (this may be a nice future extension), so the latest sync
"wins". Cobbler replicate is, generally, designed to have a
"master" concept, so it is probably not desirable yet to do
bi-directional syncing.

## Common Use Cases

## High Availability / Disaster Recovery

A remote cobbler server periodically replicates from the master to
keep an active installation.

## Load Balancing

Similar to the HA / Disaster Recovery case, consider using a
[CobblerTrigger](Triggers) to notify the other
server to pull new metadata when commands are issued.

## Multiple Geographies

Several remote servers pull from the master, either triggered by a
[CobblerTrigger](Triggers) on the central
server, or otherwise on daily cron. This allows for establishing
install mirrors that are closer and therefore faster and less
bandwidth hungry. The admin can choose whether or not system
records should be centrally managed. It may be desirable to just
centrally provide the distributions and profiles and keep the
system records on each seperate cobbler server, however, there is
nothing to say all records can't be kept centrally as well. (Choose
one or the other, don't do a mixture of both.)

