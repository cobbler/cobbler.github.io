---
layout: manpage
title: Managing DNS
meta: 2.8.0
---

You may want cobbler to manage the DNS entries of its client systems.  Cobbler can do so automatically by using
templates. It currently supports either dnsmasq (which also provides DHCP) or BIND. Cobbler also has the ability to
handle [DHCP Management](DHCP Management).

To use BIND, your `/etc/cobbler/modules.conf` should contain:

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

    manage_dns: 1

    restart_dns: 1

The relevant software packages also need to be present;  "cobbler check" will verify this.

## General considerations

* Your maintenance is performed on template files.  These do not take effect until a `cobbler sync` has been performed
to generate the run-time data files.

* The serial number on the generated zone files is the cobbler server's UNIX epoch time, that is, seconds since
1970-01-01 00:00:00 UTC. If, very unusually, your server's time gets reset backwards, your new zone serial number could
have a smaller number than previously, and the zones will not propagate.

## BIND considerations

In `/etc/cobbler/settings` you will need entries resembling the following:

    manage_forward_zones: ['foo.example.com', 'bar.foo.example.com']

    manage_reverse_zones: ['10.0.0', '192.168', '172.16.123']

Note that the reverse zones are in simple IP ordering, not in BIND-style "0.0.10.in-addr.arpa".

(??? CIDR for non-octet netmask ???)

### Restricting Zone Scope

DNS hostnames will be put into their "best fit" zone.  Continuing the above illustration, example hosts would be placed
as follows:

* `baz.bar.foo.example.com` as host `baz` in zone `bar.foo.example.com`
* `fie.foo.example.com` as host `fie` in `foo.example.com`
* `badsub.oops.foo.example.com` as host `badsub.oops` in `foo.example.com`

### Default and zone-specific templating

Cobbler will use `/etc/cobbler/bind.template` and `/etc/cobbler/zone.template` as a starting point for BIND's
`named.conf` and individual zone files, respectively.  You may drop zone-specific template files into the directory
`/etc/cobbler/zone_templates/` which will override the default.  For example, if you have a zone 'foo.example.com', you
may create `/etc/cobbler/zone_templates/foo.example.com` which will be used in lieu of the default
`/etc/cobbbler/zone.template` when generating that zone.  This can be useful to define zone-specific records such as MX,
CNAME, SRV, and TXT.

All template files must be user edited for the local networking environment.  Read the file and understand how BIND
works before proceeding.

BIND's `named.conf` file and all zone files will be updated only when "cobbler sync" is run, so it is important to
remember to use it.

### Other

Note that your client's system interfaces _must_ have a `--dns-name` set to be considered for inclusion in the zone
files. If "cobbler system report" shows that your `--dns-name` is unset, it can be set by:

    cobbler system edit --name=foo.example.com --dns-name=foo.example.com

You can set a different such name per interface and each will get its own respective DNS entry.

## DNSMASQ considerations

You should review and adjust the contents of `/etc/cobbler/dnsmasq.template`.
