---
layout: manpage
title: Cobbler Manual
---
## Power Management

Cobbler allows for linking your power management systems with
cobbler, making it very easy to make changes to your systems when
you want to reinstall them, or just use it to remember what the
power management settings for all of your systems are. For
instance, you can just change what profile they should run and flip
their power states to begin the reinstall!

## What's Supported

All of the following modes are supported. Most all of them use the
fence scripts internally so you will want fence installed. This is
part of the 'cman' package for some distributions, though it's
fence-agents in Fedora 11 and later (which cobbler has as a
dependency on that OS for newer versions).

    bullpap
    wti
    apc_snmp
    ether_wake
    ipmilan
    drac
    ipmitool
    ilo
    rsa
    lpar
    bladecenter

## Example of Set Up

You have a WTI powerbar. Define that system foo is a part of that
powerbar on plug 7

    cobbler system edit --name foo --power-type=wti --power-address=foo-mgmt.example.org --power-user Administrator --power-pass PASSWORD --power-id 7

You have a DRAC based blade:

    cobbler system edit --name blade7 --power-type=drac --power-address=blade-mgmt.example.org --power-user Administrator --power-pass=PASSWORD --power-id blade7

You have an IPMI based system:

    cobbler system edit --name foo --power-type=ipmi --power-address=foo-mgmt.example.org --power-user Administrator --power-pass=PASSWORD

You have a IBM HMC managed system:

    cobbler system edit --name 9115-505 --power-type=lpar --power-address=ibm-hmc.example.org --power-user hscroot --power-pass=PASSWORD --power-id system:partition

> **NOTE**: The *--power-id* option is used to indicate **both** the
> managed system name and a logical partition name. Since an IBM HMC
> is responsible for managing more than one system, you must supply
> the managed system name and logical partition name separated by a
> colon (':') in the --power-id command-line option.

You have an IBM Bladecenter:

    cobbler system edit --name blade-06 --power-type=bladecenter --power-address=blademm.example.org --power-user USERID --power-pass=PASSW0RD --power-id 6

> **NOTE**: The *--power-id* option is used to specify what slot your
> blade is connected.

## Data Entry

Tip: to make life easier, you can use
cobbler find + xargs [CommandLineSearch](Command Line Search)
to batch populate the settings for lots of systems.

## Defaults

If --power-user and --power-pass are left blank, the values of
default\_power\_user and default\_power\_pass will be loaded from
cobblerd's environment at the time of usage.

--power-type also has a default value in /etc/cobbler/settings,
initially set to "ipmi".

## Using the Power Management Features

Assigning A System To Be Installed To A New Profile

    cobbler system edit --name=foo --netboot-enabled=1 --profile=install-this-profile-name-instead

Powering Off A System

    cobbler system poweroff --name=foo

Powering On A System

    cobbler system poweron --name=foo

Rebooting A System (if netboot-enabled is turned on, it will now
reinstall to the new profile -- assuming PXE is working)

    cobbler system reboot --name=foo

Since not all power management systems support reboot, this is a
"power off, sleep for 1 second, and power on" operation.

## Web App Integration

Systems can be power cycled through the systems page of the web
application, even if they are on different power management
systems. See [CobblerWeb?](/cobbler/wiki/CobblerWeb) for more
details.

## Implementation

The individual command syntaxes are generated from Cheetah
templates in /etc/cobbler/power in case you need to modify the
commands or add additional options. You can also add new power
types if you like if you are using Cobbler 2.0 and later, just by
making new files in that directory.

## Important: Security Implications

Storing the power control usernames and passwords in Cobbler means
that information is essentially public (this data is available via
XMLRPC without access control), therefore you will want to control
what machines have network access to contact the power management
devices if you use this feature (such as /only/ the cobbler
machine, and then control who has local access to the cobbler
machine). Also do not reuse important passwords for your power
management devices. If this concerns you, you can still use this
feature, just don't store the username/password in Cobbler for your
power management devices.

If you are not going to to store power control passwords in
Cobbler, leave the username and password fields blank.

Cobbler will first try to source them from it's environment using
the COBBLER\_POWER\_USER and COBBLER\_POWER\_PASS variables.

This may also be too insecure for some, so in this case, don't set
these, and supply --power-user and --power-pass when running
commands like "cobbler system poweron" and "cobbler system
poweroff". The values used on the command line are always used,
regardless of the value stored in Cobbler or the environment, if so
provided.

    cobbler system poweron --name=foo --power-user=X --power-pass=Y

Be advised of current limitations in storing passwords, make your
choices accordingly and in relation to the ease-of-use that you
need, and secure your networks appropriately.

