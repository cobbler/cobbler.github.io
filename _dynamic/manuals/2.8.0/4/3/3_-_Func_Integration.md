---
layout: manpage
title: Func Integration
meta: 2.8.0
---

<div class="alert alert-info alert-block"><b>Warning:</b> This feature has been deprecated and will not be available in Cobbler 3.0.</div>

Func is a neat tool, (which, in full disclosure, Michael had a part
in creating). Read all about it at
[https://fedorahosted.org/func](https://fedorahosted.org/func)

Integration with kickstart is pretty easy, see
[https://fedorahosted.org/func/wiki/InstallAndSetupGuide](https://fedorahosted.org/func/wiki/InstallAndSetupGuide)
and
[https://fedorahosted.org/func/wiki/IntegratingWithProvisioning](https://fedorahosted.org/func/wiki/IntegratingWithProvisioning)

## Even Easier Integration

Cobbler makes it even easier to deploy Func though. We have two
settings in `/etc/cobbler/settings`:

    func_master: overlord.example.org
    func_auto_setup: 1

This will make sure the right packages are in packages for each
kickstart and the right bits are automatically in %post to set it
up... so a new user can set up a cobbler server, set up a func
overlord, and automatically have all their new kickstarts
configurable to point at that overlord.

This will be available in all the sample kickstart files, but will
be off by default. To enable this feature all you need to do then
is set up

## How This Is Implemented

This is all powered by cobbler's
[Kickstart Templating](Kickstart Templating) and
[Kickstart Snippets](Kickstart Snippets) feature, with
two snippets that ship stock in `/var/lib/cobbler/snippets`

    %packages
    koan
    ...
    $func_install_if_enabled 

    %post
    ...
    SNIPPET:func_register_if_enabled

If curious you can read the implementations in
`/var/lib/cobbler/snippets` and these are of course controlled by the
aforemented values in settings.

The "func\_register\_if\_enabled" snippet is pretty basic.

It configures func to point to the correct certmaster to get
certificates and enables the service. When the node boots into the
OS it will request the certificate (see note on autosigning below)
and func is now operational. If there are problems, see
`/var/log/func` and `/var/log/certmaster` for debugging info (or other
resources and information on the Func Wiki page). Func also has an
IRC channel and mailing list as indicated on
[http://fedorahosted.org/func](http://fedorahosted.org/func)

## Notes about Func Autosigning

This may work better for you if you are using Func autosigning,
otherwise the administrator will need to use certmaster-ca --sign
hostname (see also certmaster-ca --list) to deal with machines.

Not using autosigning is good if you don't trust all the hosts you
are provisioning and don't want to enslave unwanted machines.

Either choice is ok, just be aware of the manual steps required if
you don't enable it, or the implications if you do.

## Package Hookup

If you are not already using Cobbler to mirror package content, you
are going to want to, so that you can make the func packages
available to your systems -- they are not part of the main install
"tree".

Thankfully Cobbler makes this very simple -- see
[Manage Yum Repos](Manage Yum Repos) for details

### for Fedora

Func is part of the package set for Fedora, but you need to mirror
the "Everything" repo to get at it. Therefore you will want to
mirror "Everything" and make it available to your cobbler profiles
so you can effectively put func on your installed machines. You
will also want to mirror "updates" to make sure you get the latest
func.

An easy way to mirror these with cobbler is just:

    cobbler repo add --name=f10-i386-updates --mirror=http://download.fedora.redhat.com/pub/fedora/linux/updates/10/i386/
    cobbler repo add --name=f10-i386-everything --mirror=http://download.fedora.redhat.com/pub/fedora/linux/releases/10/Everything/i386/os/Packages/

Then you need to make sure that every one of your Fedora profiles
is set up to use the appropriate repos:

    cobbler profile edit --name=f10-profile-name-goes-here --repos="f10-i386-updates f10-i386-everything"

And then you would probably want to put 'cobbler reposync' on cron
so you keep installing the latest func, not an older func.

### for Enterprise Linux 4 and 5

As with Fedora, you'll need to configure your systems as above to
get func onto them, and that is not included as part of the Func
integration process. RHEL 5 uses yum, so it can follow similar
instructions as above. That's very simple. In those cases you will
just want to mirror the repositories for EPEL:

    cobbler repo add --name=el-5-i386-epel --mirror=http://download.fedora.redhat.com/pub/epel/5/i386
    cobbler repo add --name=el-5-i386-epel-testing --mirror=http://download.fedora.redhat.com/pub/epel/testing/5/i386 

Of course in the above you would want to substitute '4' for '5' if
neccessary and also 'i386' for 'x86\_64' if neccessary. You will
probably want to mirror multiples of the above. Cobbler doesn't
care, just go ahead and do it. If you have space concerns, as
discussed on [Manage Yum Repos](Manage Yum Repos) you can
use the --rpm-list parameter to do partial yum mirroring.

Once you do this, you will need to make sure your EL profiles (for
those that support yum, i.e. the EL 5 and later ones) know about
the repos and attach to them automatically:

    cobbler profile edit --name=el5-profile-name-goes-here --repos="el-5-i386-epel el-5-i386-epel-testing"

Another simple option is to just put the func RPMs on a webserver
somewhere and wget them from the installer so they are available at
install time, you would do this as the very first step in post.

    %post
    wget http://myserver.example.org/func-version.rpm -O /tmp/func.rpm
    rpm -i /tmp/func.rpm 

## Func Questions

See \#func on irc.freenode.net and func-list@redhat.com

