---
layout: manpage
title: Advanced Networking - Bridging
meta: 2.8.0
---

A bridge is a way to connect two Ethernet segments together in a protocol independent way. Packets are forwarded based
on Ethernet address, rather than IP address (like a router). Since forwarding is done at Layer 2, all protocols can go
transparently through a bridge. ([reference](http://www.linuxfoundation.org/collaborate/workgroups/networking/bridge)). 

You can create a bridge in cobbler in the following way:

{% highlight bash %}
$ cobbler system edit --name=foo --interface=eth0 --mac=AA:BB:CC:DD:EE:F0 --interface-type=bridge_slave --interface-master=br0
$ cobbler system edit --name=foo --interface=eth1 --mac=AA:BB:CC:DD:EE:F1 --interface-type=bridge_slave --interface-master=br0
$ cobbler system edit --name=foo --interface=br0 --interface-type=bridge --bridge-opts="stp=no" --ip-address=192.168.1.100 --netmask=255.255.255.0
{% endhighlight %}

You can specify any bridging options you would like, so please read the brctl manpage for details if you are unfamiliar
with bridging.

**NOTE** You must install the bridge-utils package during the build process for this to work in the %post section of
your build.
