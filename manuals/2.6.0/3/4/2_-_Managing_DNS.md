---
layout: manpage
title: Managing DNS
meta: 2.6.0
---

You may want cobbler to manage the DNS entries of its client systems. Cobbler can do so automatically by using
templates. It currently supports either dnsmasq (which also provides DHCP) or BIND. Cobbler also has the ability to
handle <a href="DHCP%20Management">DHCP Management</a>.

<p>To use BIND, your <code>/etc/cobbler/modules.conf</code> should contain:</p>

<pre><code>[dns]
module = manage_bind

[dhcp]
module = manage_isc
</code></pre>

<p>To use dnsmasq, it should contain:</p>

<pre><code>[dns]
module = manage_dnsmasq

[dhcp]
module = manage_dnsmasq
</code></pre>

<p>You should not try to mix these.</p>

<p>You also need to enable such management; this is done in <code>/etc/cobbler/settings</code>:</p>

<pre><code>manage_dns: 1

restart_dns: 1
</code></pre>

<p>The relevant software packages also need to be present;  "cobbler check" will verify this.</p>

<h2>General considerations</h2>

<ul>
<li><p>Your maintenance is performed on template files.  These do not take effect until a <code>cobbler sync</code> has been performed to generate the run-time data files.</p></li>
<li><p>The serial number on the generated zone files is the cobbler server's UNIX epoch time, that is, seconds since 1970-01-01 00:00:00 UTC. If, very unusually, your server's time gets reset backwards, your new zone serial number could have a smaller number than previously, and the zones will not propagate.</p></li>
</ul>


<h2>BIND considerations</h2>

<p>In <code>/etc/cobbler/settings</code> you will need entries resembling the following:</p>

<pre><code>manage_forward_zones: ['foo.example.com', 'bar.foo.example.com']

manage_reverse_zones: ['10.0.0', '192.168', '172.16.123']
</code></pre>

<p>Note that the reverse zones are in simple IP ordering, not in BIND-style "0.0.10.in-addr.arpa".</p>

<p>(??? CIDR for non-octet netmask ???)</p>

<h3>Restricting Zone Scope</h3>

<p>DNS hostnames will be put into their "best fit" zone.  Continuing the above illustration, example hosts would be placed as follows:</p>

<ul>
<li><code>baz.bar.foo.example.com</code> as host <code>baz</code> in zone <code>bar.foo.example.com</code></li>
<li><code>fie.foo.example.com</code> as host <code>fie</code> in <code>foo.example.com</code></li>
<li><code>badsub.oops.foo.example.com</code> as host <code>badsub.oops</code> in <code>foo.example.com</code></li>
</ul>


<h3>Default and zone-specific templating</h3>

<p>Cobbler will use <code>/etc/cobbler/bind.template</code> and <code>/etc/cobbler/zone.template</code> as a starting point for BIND's <code>named.conf</code> and individual zone files, respectively.  You may drop zone-specific template files into the directory <code>/etc/cobbler/zone_templates/</code> which will override the default.  For example, if you have a zone 'foo.example.com', you may create <code>/etc/cobbler/zone_templates/foo.example.com</code> which will be used in lieu of the default <code>/etc/cobbbler/zone.template</code> when generating that zone.  This can be useful to define zone-specific records such as MX, CNAME, SRV, and TXT.</p>

<p>All template files must be user edited for the local networking environment.  Read the file and understand how BIND works before proceeding.</p>

<p>BIND's <code>named.conf</code> file and all zone files will be updated only when "cobbler sync" is run, so it is important to remember to use it.</p>

<h3>Other</h3>

<p>Note that your client's system interfaces <em>must</em> have a <code>--dns-name</code> set to be considered for inclusion in the zone files.  If "cobbler system report" shows that your <code>--dns-name</code> is unset, it can be set by:</p>

<pre><code>cobbler system edit --name=foo.example.com --dns-name=foo.example.com
</code></pre>

<p>You can set a different such name per interface and each will get its own respective DNS entry.</p>

<h2>DNSMASQ considerations</h2>

<p>You should review and adjust the contents of <code>/etc/cobbler/dnsmasq.template</code>.</p>
