---
layout: post
title: Speeding up Triggers
author: Alastair Munro
summary: Speeding up triggers to sync remote cobbler servers
---

###  One master and three slave cobbler setup

For our setup we have one master and three cobbler slaves. In effect one cobbler server per data center for our four
data centers. This means no installs across wan links and our server builds are setup with their yum repos pointing to
the local cobbler server (use cobbler as yum repos). 

We have simple admin as its only done on the master, which is the only cobbler server with cobbler web. Thus we have a
standard config across all servers, with local site differences in the cobbler settings file. You only have to remember
to set the server override for systems at remote sites. 

We do a mix of pxe and generated.iso builds and cobbler allows lots of flexibility in this respect (pxe boot where you
have dhcp/tftp; otherwise use the generated.iso and map it using vmware/ilo/etc).

### How replication works

The cobbler docs describe how to setup replication. The master server uses triggers and ssh's to the slave servers and
runs a `cobbler replicate`.

However when running triggers to run the replicate, the cobbler web page waits for the ssh at the remote end to
complete. This produces quite a delay. The reason for this is it waits for the ssh to complete, even if you background
or nohup it. If you have just added a new distro, the web page would most likely timeout and throw an error. Horrible!

### Introducing daemon

I found a way to run the remote command without waiting. Using daemon from [here](http://libslack.org/daemon/). This
daemonizes the ssh command, thus giving an instant response. The web page returns instantly, and a system
add/edit/delete will be in sync on the remote server within 5 seconds.

The other nice thing about daemon is the `--name=<name>` switch; daemon will only allow the command to run if there is
not another daemon running with the same name. Thus you could put the same replicate command in cron to run every so
often on the slave, to ensure its kept up to date. This means the cron and trigger runs would never clash, or subsequent
cron runs would not clash with an earlier run. For example if you add a new distro, the replicate command can take a
while to run and the next cron run may run into it.

Running cobbler on centos 6, I install the prebuilt rpm's on the daemon download page.

The trigger script. You should symbolic link this into delete/system/post and also symbolic link it for profiles in a
similar manner (adding a distro creates a profile and thus will force a trigger):

     # cat /var/lib/cobbler/triggers/add/system/post/sync-slaves.sh
     #!/bin/bash
     # A Munro 6 Aug 2014: sync slaves
     # make sure you set up ssh keys for this...
     # 
     # space delimited list of slaves
     SLAVES="cob-london cob-hamilton cob-columbus
     MASTER=cobbler
     SSH="ssh -oConnectTimeout=2 -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -oBatchMode=yes -oLogLevel=quiet"
     LOG=/var/log/cobbler/triggers.log

     [ -f $LOG ] && rm -f $LOG

     for h in $SLAVES
     do
     #   slow ssh way: waits to complete
     #    $SSH $h "cobbler replicate --master=$MASTER --systems=* --profiles=* --prune" 2>&1 >> $LOG  &
     #   using daemon
        $SSH $h "daemon --name=cob /usr/local/cobbler/sync-master.sh" 2>&1 >> $LOG  &
     done

The slave script; this is sufficient as it will sync any dependant objects such as distros automatically:

    # cat /usr/local/cobbler/sync-master.sh
    cobbler replicate --master=cobbler --systems=* --profiles=* --prune
