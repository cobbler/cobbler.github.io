---
layout: manpage
title: Advanced Networking
meta: 2.8.0
nav: 1 - Advanced Networking
navversion: nav28
---

This page details some of the networking tips and tricks in more detail, regarding what you can set on system records to
set up networking, without having to know a lot about kickstart/Anaconda.

These features include:

-   Arbitrary NIC naming (the interface is matched to a physical
    device using it's MAC address)
-   Configuring DNS nameserver addresses
-   Setting up NIC bonding
-   Defining for static routes
-   Support for VLANs

If you want to use any of these features, it's highly recommended
to add the MAC addresses for the interfaces you're using to Cobbler
for each system.

## Arbitrary NIC naming

You can give your network interface (almost) any name you like.

{% highlight bash %}
$ cobbler system edit --name=foo1.bar.local --interface=mgmt --mac=AA:BB:CC:DD:EE:F0
$ cobbler system edit --name=foo1.bar.local --interface=dmz --mac=AA:BB:CC:DD:EE:F1
{% endhighlight %}

The default interface is named eth0, but you don't have to call it that.

Note that you can't name your interface after a kernel module you're using. For example: if a NIC is called 'drbd', the
module drbd.ko would stop working. This is due to an "alias" line in /etc/modprobe.conf.

## Name Servers

For static systems, the --name-servers parameter can be used to
specify a list of name servers to assign to the systems.

{% highlight bash %}
$ cobbler system edit --name=foo --interface=eth0 --mac=AA:BB:CC::DD:EE:FF --static=1 --name-servers="<ip1> <ip2>"
{% endhighlight %}

## Static routes

You can define static routes for a particular interface to use with --static-routes. The format of a static route is:

<code>
network/CIDR:gateway
</code>

So, for example to route the 192.168.1.0/24 network through 192.168.1.254:

{% highlight bash %}
$ cobbler system edit --name=foo --interface=eth0 --static-routes="192.168.1.0/24:192.168.1.254"
{% endhighlight %}

As with all lists in cobbler, the --static-routes list is space-separated so you can specify multiple static routes if
needed.

## Kickstart Notes

Three different networking [Snippets]({% link manuals/2.8.0/3/6_-_Snippets.md %}) must be present in your kickstart
files for this to work:

<pre>
pre_install_network_config
network_config
post_install_network_config
</pre>

The default kickstart templates (`/var/lib/cobbler/kickstart/sample\*.ks`) have these installed by default so they work
out of the box. Please use those files as a reference as to where to correctly include the $SNIPPET definitions.
