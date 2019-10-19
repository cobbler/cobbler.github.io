---
layout: manpage
title: File System ACLs
meta: 2.6.0
---

Cobbler contains an "aclsetup" command for automation of setting up file system acls (i.e. setfacl) on directories that
cobbler needs to read and write to.

## Using File System ACLs

Usage of this command allows the administrator to grant access to other users without granting them the ability to run
cobbler as root.

{% highlight bash %}
$ cobbler aclsetup --help
Usage: cobbler aclsetup  [ARGS]

Options:
  -h, --help            show this help message and exit
  --adduser=ADDUSER     give acls to this user
  --addgroup=ADDGROUP   give acls to this group
  --removeuser=REMOVEUSER
                        remove acls from this user
  --removegroup=REMOVEGROUP
                        remove acls from this group
{% endhighlight %}

Example: `$ cobbler aclsetup --adduser=timmy`

The above example gives timmy access to run cobbler commands.

Note that aclsetup does grant access to configure all of `/etc/cobbler`, `/var/www/cobbler`, and `/var/lib/cobbler`, so
it is still rather powerful in terms of the access it grants (though somewhat less so than providing root).

A user with acls can, for instance, edit cobbler triggers which are later run by cobblerd (as root). In this event,
cobbler access (either sudo or aclsetup) should not be granted to users you do not trust completely. This should not be
a major problem as in giving them access to configure future aspects of your network (via the provisioning server) they
are already being granted fairly broad rights.

It is at least nicer than running "sudo" all of the time if you were going to grant a user "no password" sudo access to cobbler.
