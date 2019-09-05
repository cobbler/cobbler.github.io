---
layout: manpage
title: Configuration Management
meta: 2.8.0
---


The initial provisioning of client systems with cobbler is just one component of their management. We also need to
consider how to continue to manage them using a configuration management system (CMS). Cobbler can help you provision
and introduce a CMS onto your client systems.

One option is cobbler's own lightweight CMS. For that, see the document [Built in configuration management](Built in configuration management).

Here we discuss the other option: deploying a CMS such as puppet, cfengine, bcfg2, Chef, etc.

Cobbler doesn't force you to chose a particular CMS (or to use one at all), though it helps if you do some things to
link cobbler's profiles with the "profiles" of the CMS. This, in general, makes management of both a lot easier.

Note that there are two independent "variables" here: the possible client operating systems and the possible CMSes. We
don't attempt to cover all details of all combinations; rather we illustrate the principles and give a small number of
illustrative examples of particular OS/CMS combinations. Currently cobbler has better support for Redhat-based OSes and
for Puppet so the current examples tend to deal with this combination.

## Background considerations

### Machine lifecyle

A typical computer has a lifecycle something like:

* installation
* initial configuration
* ongoing configuration and maintenance
* decommissioning

Typically installation happens once.  Likewise, the initial configuration happens once, usually shortly after
installation. By contrast ongoing configuration evolves over an extended period, perhaps of several years. Sometimes
part of that ongoing configuration may involve re-installing an OS from scratch.  We can regard this as repeating the
earlier phase.

We need not consider decommissioning here.

Installation clearly belongs (in our context) to Cobbler.  In a complementary manner, ongoing configuration clearly
belongs to the CMS. But what about initial configuration?

Some sites consider their initial configuration as the final phase of installation: in our context, that would put it at
the back end of Cobbler, and potentially add significant configuration-based complication to the installation-based
Cobbler set-up.

But it is worth considering initial configuration as the first step of ongoing configuration: in our context that would
put it as part of the CMS, and keep the Cobbler set-up simple and uncluttered.

### Local package repositories

Give consideration to:

- local mirrors of OS repositories
- local repository of local packages
- local repository of pick-and-choose external packages

In particular consider having the packages for your chosen CMS in one of the latter.

### Package management

Some sites set up Cobbler always to deploy just a minimal subset of packages, then use the CMS to install many others in
a large-scale fashion.  Other sites may set up Cobbler to deploy tailored sets of packages to different types of
machines, then use the CMS to do relatively small-scale fine-tuning of that.

## General scheme

We need to consider getting Cobbler to install and automatically invoke the CMS software.

Set up Cobbler to include a package repository that contains your chosen CMS:

    cobbler repo add ...

Then (illustrating a Redhat/Puppet combination) set up the kickstart file to say something like:

    %packages
    puppet

    %post
    /sbin/chkconfig --add puppet

The detail may need to be more substantial, requiring some other associated local packages, files and configuration. You
may wish to manage this through [Kickstart snippets](Kickstart Snippets).

## Conclusion

Hopefully this should get you started in linking up your provisioning configuration with your CMS implementation. The
examples provided are for Puppet, but we can (in the future) presumably extend --mgmt-classes to work with other
tools... just let us know what you are interested in, or perhaps take a shot at creating a patch for it.

