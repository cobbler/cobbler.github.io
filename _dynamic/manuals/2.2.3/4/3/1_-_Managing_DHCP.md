---
layout: manpage
title: Managing DHCP
meta: 2.2.3
---

You may want cobbler to manage the DHCP entries of its client systems. It currently supports either ISC DHCP or dnsmasq (which, despite the name, supports DHCP). Cobbler also has the ability to handle [DNS Management](DNS Management).

To use ISC, your `/etc/cobbler/modules.conf` should contain:

    [dns]
    module = manage_bind
    
    [dhcp]
    module = manage_isc
    
To use dnsmasq, it should contain:

    [dns]
    module = manage_dnsmasq
    
    [dhcp]
    module = manage_dnsmasq

You should not try to mix these.

You also need to enable such management; this is done in `/etc/cobbler/settings`:

    manage_dhcp: 1

    restart_dhcp: 1

The relevant software packages also need to be present;  "cobbler check" will verify this.

## When To Enable DHCP Management

DHCP is closely related to PXE-based installation.  If you are maintaining a database of your systems and what they run, it can make sense also to manage hostnames and IP addresses. Controlling DHCP from Cobbler can coordinate all this. This capability is a good fit if you can control DHCP for a lab or datacenter and want to run DHCP from the same server where you are running Cobbler. If you have an existing configuration of things that cobbler shouldn't be managing, you can copy them into your `/etc/cobbler/dhcp.template`.

The default behaviour is for cobbler _not_ to manage your DHCP infrastructure. Make sure that in your existing `dhcp.conf` the next-server entry and filename information are correct to serve up pxelinux.0 to the machines that want it (for the case of bare metal installations over PXE).

## Setting up

### ISC considerations

The master DHCP file when run from cobbler is `/etc/cobbler/dhcp.template`, not the more usual `/etc/dhcpd.conf`. Edit this template file to suit your environment; this is mainly just making sure that the DHCP information is correct. You can also include anything you may have had from an existing setup.

### DNSMASQ considerations

If using dnsmasq, the template file is `/etc/cobbler/dnsmasq.template` but it basically works as for ISC (above). Remember that dnsmasq also provides DNS.

## How It Works

Suppose the following command is given (where &lt;profile name&gt; is an existing profile in cobbler):

    cobbler system add --name=foo --profile=<profile name> --interface=eth0 --mac=AA:BB:CC:DD:EE:FF --ip-address=192.168.1.1

That will take the template file in `/etc/cobbler/dhcp.template`, fill in the appropriate fields, and generate a fuller configuration file `/etc/dhcpd.conf` that includes this machine, and ensures that when AA:BB:CC:DD:EE:FF asks for an IP, it gets 192.168.1.1. The `--ip-address=...` specification is optional; DHCP can make dynamic assignments within a configured range.

To make this active, run:

    cobbler sync

## Itanium: additional requirements

Itanium-based systems are more complicated and special the other architectures, because their bootloader is not as intelligent, and requires a "filename" value that references elilo, not pxelinux.

* When creating the distro object, make sure that `--arch=ia64` is specified.
* You need to create system objects, and the `--mac-address` argument is mandatory. (This is due to a deficiency in LILO where it will ask for an encoded IP address, but will not ask for a PXE configuration file based on the MAC address.)
* You need to specify the `--ip-address=...` value on system objects.
* In `/etc/cobbler/settings`, you must (for now) choose `dhcp_isc`.

Also, sometimes Itaniums tend to hang during net installs; the reasons are unknown.

## ISC and OMAPI for dynamic DHCP updates

OMAPI support for updating ISC DHCPd is actually not supported.
This was a buggy feature (we think OMAPI itself is buggy) and
apparently OMAPI is slated for removal in a future version of ISC
dhcpd.

## Static IPs

Lots of users will deploy with DHCP for PXE purposes and then use the Anaconda installer or other mechanism to configure static networking.  For this, you do not need to use this DHCP Management feature. Instead you can configure your DHCP to provide a dynamic range, and configure the static addresses by other mechanisms.

For instance `cobbler system ...` can set each interface.  Cobbler's default [Kickstart Snippets](Kickstart Snippets) will handle the rest.

Alternatively, if your site uses a [Configuration Management System](Using cobbler with a configuration management system) that might be suitable for such configuration.

## If You Don't Have Any DHCP

If you don't have any DHCP at all, you can't PXE, and you can
ignore this feature, but you can still take advantage of
[Build Iso](Build Iso) for bare metal installations.
This is also good for installing machines on different networks
that might not have a next-server configured.

