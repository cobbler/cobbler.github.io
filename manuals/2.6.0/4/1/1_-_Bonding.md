---
layout: manpage
title: Advanced Networking - Bonding
meta: 2.6.0
nav: 1 - Bonding
navversion: nav26
---

<p>Bonding is also known as trunking, or teaming. Different vendors use different names. It's used to join multiple physical interfaces to one logical interface, for redundancy and/or performance.</p>

<p>You can set up a bond, to join interfaces eth0 and eth1 to a failover (active-backup) interface bond0 as follows:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler system edit --name=foo --interface=eth0 --mac=AA:BB:CC:DD:EE:F0 --interface-type=bond_slave --interface-master=bond0
$ cobbler system edit --name=foo --interface=eth1 --mac=AA:BB:CC:DD:EE:F1 --interface-type=bond_slave --interface-master=bond0
$ cobbler system edit --name=foo --interface=bond0 --interface-type=bond --bonding-opts=&quot;miimon=100 mode=1&quot; --ip-address=192.168.1.100 --netmask=255.255.255.0</code></pre></figure></p>

<p>You can specify any bonding options you would like, so please read the kernel documentation if you are unfamiliar with the various bonding modes Linux can support.</p>

<h3>Notes About Bonding Syntax</h3>

<p>The methodology to create bonds was changed in 2.2.x with the introduction of bridged interface support. The <strong>--bonding</strong> and <strong>--bonding-master</strong> options have since been deprecated and are now an alias to <strong>--interface-type</strong> and <strong>--interface-master</strong>, respectively.</p>

<p>Likewise, the master/slave options have been deprecated in favor of bond/bond_slave. Cobbler will continue to read system objects that have those fields set, but when the object is edited and saved back to disk they will be converted to the new format transparently.</p>
