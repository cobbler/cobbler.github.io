---
layout: manpage
title: Command Line Search
meta: 2.8.0
---

Command line search can be used to ask questions about your cobbler
configuration, rather than just having to run "cobbler list" or
"cobbler report" and scanning through the results. (The
[Cobbler Web Interface](Cobbler Web Interface) also
supports search/filtering, for those that want to use it, though
that is not documented on this page)

Command line search works on all distro/profile/system/and repo
objects.

    cobbler distro find --help
    cobbler profile find --help
    cobbler system find --help
    cobbler repo find --help

NOTE: Some of these examples are kind of arbitrary. I'm sure you
can think of some more real world examples.

## Examples

Find what system record has a given mac address.

        cobbler system find --mac=AA:BB:CC:DD:EE:FF

If anything is using a certain kernel, delete that object and all
it's children (profiles, systems, etc).

     
        cobbler distro find --kernel=/path/to/kernel | xargs -n1 --replace cobbler distro remove --name={} --recursive

What profiles use the repo "epel-5-i386-testing" ?

        cobbler profile find --repos=epel-5-i386-testing

Which profiles are owned by neo AND mranderson?

       cobbler profile find --owners="neo,mranderson"
       # lists need to be comma delimited, like this, with no unneeded spaces

What systems are set to pass the kernel argument "color=red" ?

       cobbler system find --kopts="color=red"

What systems are set to pass the kernel argument "color=red" and
"number=5" ?

       cobbler system find --kopts="color=red number=5"
       # space delimited key value pairs
       # key1=value1 key2 key3=value3
      

What systems set the kickstart metadata variable of foo to the
value 'bar' ?

       cobbler system find --ksmeta="foo=bar"
       # space delimited key value pairs again

What systems are set to netboot disabled?

       cobbler system find --netboot-enabled=0
       # note, this also accepts 'false', or 'no'

For all systems that are assigned to profile "foo" that are set to
netboot disabled, enable them.

       cobbler system find --profile=foo --netboot-enabled=0 | xargs -n1 --replace cobbler system edit --name={} --netboot-enabled=1
       # demonstrates an "AND" query combined with xargs usage.

## A Note About Types And Wildcards

Though the cobbler objects behind the scenes store data in various
different formats (booleans, hashes, lists, strings), it all works
fom the command line as text.

If multiple terms are specified to one argument, the search is an
"AND" search.

If multiple parameters are specified, the search is still an "AND"
search.

The find command understands patterns such as "\*" and "?". This is
supported using Python's fnmatch.

To learn more:

    pydoc fnmatch.fnmatch

All systems starting with the string foo:

    cobbler system find --name="foo*"

This is rather useful when combined with xargs. This is a rather
tame example, reporting on all systems starting with "TEST".

    cobbler system find --name="TEST*" | xargs -n1 --replace cobbler system 
    report --name={}

By extension, you could use this to toggle the --netboot-enabled
systems of machines with certain hostnames, mac addresses, and so
forth, or perform other kinds of wholesale edits (for instance,
deletes, or assigning profiles with certain names to new distros
when upgrading them from F8 to F9, for instance).

## API Usage

All of this functionality is also exposed through the API

    #!/usr/bin/python
    import cobbler.api as capi
    api_handle = capi.BootAPI()
    matches = api_handle.find_profile(name="TEST*",return_list=True)
    print matches

You will find uses of ".find()" throughout the cobbler code that
make use of this behavior.

