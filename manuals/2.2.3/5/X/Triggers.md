---
layout: manpage
title: Cobbler Manual
---
## About

Cobbler triggers provide a way to tie user-defined actions to
certain cobbler commands -- for instance, to provide additional
logging, integration with apps like Puppet or cfengine, set up SSH
keys, tieing in with a DNS server configuration script, or for some
other purpose.

Cobbler Triggers should be Python modules written using the low-level
Python API for maximum speed, but could also be simple executable shell
scripts.

As a general rule, if you need access to Cobbler's object data from
a trigger, you need to write the trigger as a module. Also never
invoke cobbler from a trigger, or use Cobbler XMLRPC from a
trigger. Essentially, cobbler triggers can be thought of as plugins
into cobbler, though they are not essentially plugins per se.

## Trigger Names (for Old-Style Triggers)

Cobbler script-based triggers are scripts installed in the
following locations, and must be made chmod +x.

    /var/lib/cobbler/triggers/add/system/pre/*
    /var/lib/cobbler/triggers/add/system/post/*
    /var/lib/cobbler/triggers/add/profile/pre/*
    /var/lib/cobbler/triggers/add/profile/post/*
    /var/lib/cobbler/triggers/add/distro/pre/*
    /var/lib/cobbler/triggers/add/distro/post/*
    /var/lib/cobbler/triggers/add/repo/pre/*
    /var/lib/cobbler/triggers/add/repo/post/*
    /var/lib/cobbler/triggers/sync/pre/*
    /var/lib/cobbler/triggers/sync/post/*
    /var/lib/cobbler/triggers/install/pre/*
    /var/lib/cobbler/triggers/install/post/*

And the same as the above replacing "add" with "remove".

Pre-triggers are capable of failing an operation if they return
anything other than 0. They are to be thought of as "validation"
filters. Post-triggers cannot fail an operation and are to be
thought of notifications.

We may add additional types as time goes on.

## Pure Python Triggers

As mentioned earlier, triggers can be written in pure python, and
many of these kinds of triggers ship with cobbler as stock.

Look in your site-packages/cobbler/modules directory and cat
"install\_post\_report.py" for an example trigger that sends email
when a system gets done installing.

Notice how the trigger has a register method with a path that
matches with the shell patterns above. That's how we know what type
each trigger is.

You will see the path used in the trigger corresponds with the path
where it would exist if it was a script -- this is how we know what
type of trigger the module is providing.

## The Simplest Trigger Possible

create /var/lib/cobbler/triggers/add/system/post/test.sh chmod +x
the file

    #!/bin/bash
    echo "Hi, my name is $1 and I'm a newly added system"

However that's not very interesting as all you get are the names
passed across. For triggers to be the most powerful, they should
take advantage of the Cobbler API -- which means writing them as a
Python module.

## Performance Note

If you have a very large number of systems, using the Cobbler API
from scripts with old style (non-Python modules, just scripts in
/var/lib/cobbler/triggers) is a very very bad idea. The reason for
this is that the cobbler API brings the cobbler engine up with it,
and since it's a seperate process, you have to wait for that to
load. If you invoke 3000 triggers editing 3000 objects, you can see
where this would get slow pretty quickly. However, if you write a
modular trigger (see above) this suffers no performance penalties
-- it's crazy fast and you experience no problems.

## Permissions

The /var/lib/cobbler/triggers directory is only writeable by root
(and are executed by cobbler on a regular basis). For security
reasons do not loosen these permissions.

## Example trigger for resetting Cfengine keys

Here is an example where cobbler and cfengine are running on two
different machines and xmlrpc is used to communicate between the
hosts.

Note that this uses the Cobbler API so it's somewhat inefficient --
it should be converted to a Python module-based trigger. If it were
in a pure Python modular trigger, it would fly.

On the cobbler box:

/var/lib/cobbler/triggers/install/post/clientkeys.py

    #!/usr/bin/python
    import socket
    import xmlrpclib
    import sys
    from cobbler import api
    cobbler_api = api.BootAPI()
    systems = cobbler_api.systems()
    box = systems.find(sys.argv[2])
    server = xmlrpclib.ServerProxy("http://cfengine:9000")
    server.update(box.get_ip_address())

On the cfengine box, we run a daemon that does the following (along
with a few steps to update our ssh\_known\_hosts file):

    #!/usr/bin/python
    import SimpleXMLRPCServer
    import os
    class Keys(object):
         def update(self, ip):
             try:
                os.unlink('/var/cfengine/ppkeys/root-%s.pub' % ip)
            except OSError:
                pass
    keys = Keys()
    server = SimpleXMLRPCServer.SimpleXMLRPCServer(("cfengine",9000))
    server.register_instance(keys)
    server.serve_forever()

## See Also

post by Ithiriel:

[Writing Install Triggers](http://www.ithiriel.com/content/2010/03/29/writing-install-triggers-cobbler)

