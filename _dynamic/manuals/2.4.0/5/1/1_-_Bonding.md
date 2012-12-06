---
layout: manpage
title: Advanced Networking - Bonding
meta: 2.4.0
---

Bonding is also known as trunking, or teaming. Different vendors use different names. It's used to join multiple physical interfaces to one logical interface, for redundancy and/or performance.

You can set up a bond, to join interfaces eth0 and eth1 to a failover (active-backup) interface bond0 as follows:

{% highlight bash %}
$ cobbler system edit --name=foo --interface=eth0 --mac=AA:BB:CC:DD:EE:F0 --interface-type=bond_slave --interface-master=bond0
$ cobbler system edit --name=foo --interface=eth1 --mac=AA:BB:CC:DD:EE:F1 --interface-type=bond_slave --interface-master=bond0
$ cobbler system edit --name=foo --interface=bond0 --interface-type=bond --bonding-opts="miimon=100 mode=1" --ip-address=192.168.1.100 --netmask=255.255.255.0
{% endhighlight %}

You can specify any bonding options you would like, so please read the kernel documentation if you are unfamiliar with the various bonding modes Linux can support.

### Notes About Bonding Syntax

The methodology to create bonds was changed in 2.2.x with the introduction of bridged interface support. The **--bonding** and **--bonding-master** options have since been deprecated and are now an alias to **--interface-type** and **--interface-master**, respectively.

Likewise, the master/slave options have been deprecated in favor of bond/bond_slave. Cobbler will continue to read system objects that have those fields set, but when the object is edited and saved back to disk they will be converted to the new format transparently.
