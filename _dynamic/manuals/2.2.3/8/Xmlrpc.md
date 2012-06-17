---
layout: manpage
title: Cobbler Manual
meta: 2.2.3
---
## About XMLRPC

XMLRPC is a lightweight way for computer programs written in
various languages to interact over the network. See
[http://www.xmlrpc.com/](http://www.xmlrpc.com/).

You should use the XMLRPC API for Cobbler if:

-   You want to talk to Cobbler and you are not a Python
    application/script
-   You want to talk to Cobbler and are not running on the Cobbler
    server
-   You are a non-GPLd application that wants to talk to Cobbler
    that is to be distributed to the public or customers

## Requirements

To use Cobbler's XMLRPC API, first you must set up
[Security](Security Overview) and
ensure both Apache and cobblerd are running on your cobbler server.
If you are using the authn\_spacewalk module, set
redhat\_management\_permissive: 1 in /etc/cobbler/settings.

## About These Examples

Examples of XMLRPC usage are going to be given in Python below, but
they should be easily doable in any language with XMLRPC bindings.
Java and Ruby for instance, already have solid XMLRPC bindings.

## Connecting and Logging In

To do anything with the Cobbler XMLRPC API, we must first define
the connection. This is rather simple:

    import xmlrpclib
    server = xmlrpclib.Server("http://cobbler-server.example.org/cobbler_api")

## Logging In

Cobbler information may be read without logging in, but for any
operations that modify things on the cobbler server, or initiate
actions, a login token is required. Once a token is acquired, the
token is passed to any function that requires a token as the final
argument to that remote function call.

A used token will be renewed is used at least once every 60
minutes. If the token expires, a new call to login is required to
get a new token.

    token = server.login("username","password")

## A Note About Errors And Remote Faults

Problems during operations will be relayed as XMLRPC remote faults
(remote CobblerExceptions)
rather than return codes. This prevents calling applications from
doing tedious return code checking.

Methods that are query-related, as well as the login call do return
data, but otherwise return data is not significant and can be
ignored.

## Getting Remote Data

Want to see what distros, profiles, systems, images, or repos, are
defined on a remote cobbler server? These are easily acquired.

    #!/usr/bin/python
    import xmlrpclib
    server = xmlrpclib.Server("http://127.0.0.1/cobbler_api")
    print server.get_distros()
    print server.get_profiles()
    print server.get_systems()
    print server.get_images()
    print server.get_repos()

Each of these methods return lists of nested hashes that describe
the remote data, showing each field in each cobbler object.

## Search

Rather than retrieving all objects of a given type, it's often
easier to just search for what you want directly.

    print server.find_distro({"name":"F*"})

The above example returns all distributions starting with "F" and
is good for all object types.  Any field
type can be searched. This also works for all object types, for
instance, systems:

    print server.find_system({"hostname":"*.lab.example.org"})

The list data that is returned is just as from get\_distros() or
get\_systems(), etc, but only contains matching results.

## Modification Times

Do you want to see just the systems that have changed since your
last XMLRPC query? This works as follows:

    print server.find_systems_since(seconds_since_epoch)

## Blending

The above queries return inforamation on the data in the cobbler
"database", but if we need to see it as koan (or PXE) (or
templating) would evaluate it, we can methods like:

    print server.get_system_as_rendered("system_name")

This will return things with the system data overriding the profile
data, all the way up the chain to distros and settings.

## Making Changes

In order to make changes, such as updating cobbler objects or
triggering a "sync" operation, a login token is required.

    token = server.login("username","password")

An exception will be raised if the login fails, and attempts are
logged.

We then need to get the handle of the type of object we want to
modify.

    handle = server.get_profile_handle("database-profile",token)

Note that while we can search by any criteria, the
"get\_\*\_handle" functions require a name to be passed in.

Once we have that handle we can use it to make all sorts of
changes:

    server.modify_profile(handle, "comment", "I changed the comment field to declare my appreciation of Llamas", token)

Of course, as with the Python API, we must also save the object
when we are done making changes.

    server.save_profile(handle, token)

Note how the token has to be passed to all operations in the
series.

### An Example of Creating A New Object

We use the same steps to create a new object as we do to modify an
existing one, though we have to first create an empty object with
the "new\_" call. Here is a complete example of making a new
distribution.

    import xmlrpclib
    server =  xmlrpclib.Server(http://127.0.0.1/cobbler_api)
    token = server.login("username","password")
    distro_id = server.new_distro(token)
    server.modify_distro(distro_id, 'name',   'example-distro',token)
    server.modify_distro(distro_id, 'kernel', '/opt/stuff/vmlinuz',token)
    server.modify_distro(distro_id, 'initrd', '/opt/stuff/initrd.img',token)
    server.save_distro(distro_id,token)

### An example how to add a new host

    server =  xmlrpclib.Server("http://127.0.0.1/cobbler_api")
    token = server.login(SATELLITE_USER,SATELLITE_PASSWORD)
    system_id = server.new_system(token)
    server.modify_system(system_id,"name","hostname",token)
    server.modify_system(system_id,"hostname","hostname.example.com",token)
    server.modify_system(system_id,'modify_interface', {
            "macaddress-eth0"   : "01:02:03:04:05:06",
            "ipaddress-eth0"    : "192.168.0.1",
            "dnsname-eth0"      : "hostname.example.com",
    }, token)
    server.modify_system(system_id,"profile","rhel6-x86_64",token)
    server.modify_system(system_id,"kernel_options", "foo=bar some=thing", token)
    server.modify_system(system_id,"ks_meta", "foo=bar some=thing", token)
    
    server.save_system(system_id, token)
    server.sync(token)

## Removing Objects

    server.remove_profile("name-of-profile",token)

Note that the name of the profile is used here, not the profile
handle.

The default behaviour is a recursive deletion of subobjects below
the object as well (such as child systems).

To avoid this behaviour:

    server.remove_profile("name-of-profile",token,False)

(This is one inconsistent example of a parameter appearing after
the token parameter, which was necessary to support backwards
compatibility in the API... apologies)

## Power Management

Power management actions can be accessed over XMLRPC:

    server.power_system(system_handle,power="on",token)
    server.power_system(system_handle,power="off",token)
    server.power_system(system_handle,power="reboot",token)

## Reading and Updating Kickstarts and Kickstart Snippets

It is possible to modify the contents of kickstart files and
snippets via the API:

    server.read_or_write_kickstart_template("/var/lib/cobbler/foo.ks",False,new_contents_as_a_string,token)
    server.read_or_write_snippet("/var/lib/cobbler/snippets/example_snippet,False,new_contents_as_a_string,token)

If you pass in "True" instead of "False" above, the data in the
existing snippet will be returned instead. In that case the
contents string is not used.

## Other Actions

To issue a cobbler sync command:

    server.sync(token)

Various long running operations cannot be done by XMLRPC yet, until
cobblerd has a built in task engine, which is on the list of things
to add. 

## Bonus Example: Using Perl to connect to the xmlrpc

The example code below will connect to Cobbler's XMLRPC and add a
new system with MAC address "00:0c:29:b8:ee:fb" which will use
profile "F8-i386"

    #!/usr/bin/perl
    
    use strict;
    use XMLRPC::Lite;
    
    # Build the connection
    my $xmlrpc = XMLRPC::Lite -> proxy('https://x.x.x.x/cobbler_api_rw');
    
    # Login to cobbler xmlrpm and get session token back.
    my $token = $xmlrpc->login("cobbler-xmlrpc-user", "cobbler-xmlrpc-pass")->result();
    
    # Create new system object
    my $object = $xmlrpc->new_system($token)->result();
    $xmlrpc->modify_system($object, "name", "example", $token)->result();
    $xmlrpc->modify_system($object, "profile", "F8-i386", $token)->result();
    
    # Commit the system object
    my $result = $xmlrpc->save_system($object, $token)->result();

This code essentially does the same as the following command line
switch:

    # cobbler system add --name="00:0c:29:b8:ee:fb" --mac="00:0c:29:b8:ee:fb" --profile="F8-i386"

## Further Reference

The cobbler web application (part of Cobbler pre-2.0, or in the
cobbler-web package for 2.0 and later) is implemented in XMLRPC API and 
can serve as a code reference.

From a "master" source checkout, look at web/cobbler\_web/views.py
for code examples.

Also in "remote.py" (the source code for the remote XMLRPC
interface) there are various tests at the bottom of the file that
show most of the XMLRPC functions in use. There is also pydoc
available on this file that describes the remote functions.

    pydoc cobbler.remote

## Connectivity

XMLRPC binds to localhost on port 25150 by default. For remote
access, we proxy through Apache at
[http://server/cobbler\_api](http://server/cobbler_api)

This is how SSL support is provided.

## Logging

As a sidenote, Cobbler XMLRPC uses a seperate logfile,
/var/log/cobbler/cobblerd.log, than the standard CLI operations
(cobbler.log). Remote exceptions are logged here for you to read,
and can be helpful for debugging.
