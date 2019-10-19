---
layout: manpage
title: Modules
meta: 2.8.0
---


Certain cobbler features can be user extended (in Python) by Cobbler users.

These features include storage of data (serialization), authorization, and authentication. Over time, this list of
module types will grow to support more options.  [Triggers](Triggers) are basically modules.

## See Also

-   [Security](Security Overview)
-   the cobbler command line itself (it's implemented in cobbler
    modules so it's easy to add new commands)

## Python Files And modules.conf

To create a module, add a python file in `/usr/lib/python$version/site-packages/cobbler/modules`. Then, in the
appropriate part of `/etc/cobbler/modules.conf`, reference the name of your module so cobbler knows that you want to
activate the module.

([Triggers](Triggers) that are python modules, as well as CLI python modules don't need to be listed in this file, they
are auto-loaded)

An example from the serializers is:

    [serializers]
    settings = serializer_catalog

The format of `/etc/cobbler/modules.conf` is that of Python's ConfigParser module.

        A setup file consists of sections, lead by a "[section]" header,
        and followed by "name: value" entries, with continuations and such in
        the style of RFC 822.

Each module, regardless of it's nature, must have the following function that returns the type of module (as a string)
on an acceptable load (when the module can be loaded) or raises an exception otherwise.

The trivial case for a cli module is:

    def register():
        return "cli"

Other than that, modules do not have a particular API signature -- they are "Duck Typed" based on how they are employed.
When starting a new module, look at other modules of the same type to see what functions they possess.

