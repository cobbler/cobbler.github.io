---
layout: manpage
title: Built-In Configuration Management
meta: 2.8.0
---


Cobbler is not just an installation server, it can also enable two different types of ongoing configuration management system (CMS):

* integration with an established external CMS such as [cfengine3](http://cfengine.com/) or [puppet](http://puppetlabs.com/), discussed [elsewhere](Using cobbler with a configuration management system);
* its own, much simpler, lighter-weight, internal CMS, discussed here.

## Setting up

Cobbler's internal CMS is focused around packages and templated configuration files, and installing these on client systems.

This all works using the same
[Cheetah-powered](http://cheetahtemplate.org) templating engine
used in [KickstartTemplating](/cobbler/cobbler/wiki/KickstartTemplating),
so once you learn about the power of treating your distribution
answer files as templates, you can use the same templating to drive
your CMS configuration files.

For example:

    cobbler profile edit --name=webserver \
      --template-files=/srv/cobbler/x.template=/etc/foo.conf

A client system installed via the above profile will gain a file "/etc/foo.conf" which is the result of rendering the template given by "/srv/cobbler/x.template". Multiple files may be specified; each "template=destination" pair should be placed in a space-separated list enclosed in quotes:

    --template-files="srv/cobbler/x.template=/etc/xfile.conf srv/cobbler/y.template=/etc/yfile.conf"

## Template files

Because the template files will be parsed by the Cheetah parser, they must conform to the guidelines described in [Kickstart Templating](Kickstart Templating). This is particularly important when the file is generated outside a Cheetah environment. Look for, and act on, Cheetah 'ParseError' errors in the Cobbler logs.

Template files follows general Cheetah syntax, so can include Cheetah variables. Any variables you define anywhere in the cobbler object hierarchy (distros, profiles, and systems) are available to your templates. To see all the variables available, use the command:

    cobbler profile dumpvars --name=webserver

Cobbler snippets and other advanced features can also be employed.

## Ongoing maintenance

Koan can pull down files to keep a system updated with the latest templates and variables:

    koan --server=cobbler.example.org --profile=foo --update-files

You could also use `--server=bar` to retrieve a more specific set of templating.(???) Koan can also autodetect the server if the MAC address is registered.

## Further uses

This Cobbler/Cheetah templating system can serve up templates via the magic URLs (see "Leveraging Mod Python" below). To do this ensure that the destination path given to any `--template-files` element is relative, not absolute; then Cobbler and koan won't download those files.

For example, in:

    cobbler profile edit --name=foo \
      --template-files="/srv/templates/a.src=/etc/foo/a.conf /srv/templates/b.src=1"

cobbler and koan would automatically download the rendered "a.src" to replace the file "/etc/foo/a.conf", but the b.src file would not be downloaded to anything because the destination pathname "1" is not absolute.

This technique enables using the Cobbler/Cheetah templating system to build things that other systems can fetch and use, for instance, BIOS config files for usage from a live environment.

## Leveraging Mod Python

All template files are generated dynamically at run-time. If a change is made to a template, a `--ks-meta` variable or
some other variable in cobbler, the result of template rendering will be different on subsequent runs. This is covered in more depth in the [Developer documentation](Developer documentation).

## Possible future developments

* Serving and running scripts via `--update-files` (probably staging them through "/var/spool/koan").
* Auto-detection of the server name if `--ip` is registered.
