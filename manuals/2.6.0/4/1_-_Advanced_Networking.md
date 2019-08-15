
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4_-_Advanced_Topics.html">4</a> <span class="divider">/</span></li><li class="active">Advanced Networking</li></ul>
   <h1>Advanced Networking</h1>
<p>This page details some of the networking tips and tricks in more detail, regarding what you can set on system records to set up networking, without having to know a lot about kickstart/Anaconda.</p>

<p>These features include:</p>

<ul>
<li>Arbitrary NIC naming (the interface is matched to a physical
device using it's MAC address)</li>
<li>Configuring DNS nameserver addresses</li>
<li>Setting up NIC bonding</li>
<li>Defining for static routes</li>
<li>Support for VLANs</li>
</ul>


<p>If you want to use any of these features, it's highly recommended
to add the MAC addresses for the interfaces you're using to Cobbler
for each system.</p>

<h2>Arbitrary NIC naming</h2>

<p>You can give your network interface (almost) any name you like.</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler system edit --name=foo1.bar.local --interface=mgmt --mac=AA:BB:CC:DD:EE:F0
$ cobbler system edit --name=foo1.bar.local --interface=dmz --mac=AA:BB:CC:DD:EE:F1</code></pre></figure></p>

<p>The default interface is named eth0, but you don't have to call it that.</p>

<p>Note that you can't name your interface after a kernel module you're using. For example: if a NIC is called 'drbd', the module drbd.ko would stop working. This is due to an "alias" line in /etc/modprobe.conf.</p>

<h2>Name Servers</h2>

<p>For static systems, the --name-servers parameter can be used to
specify a list of name servers to assign to the systems.</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler system edit --name=foo --interface=eth0 --mac=AA:BB:CC::DD:EE:FF --static=1 --name-servers=&quot;&lt;ip1&gt; &lt;ip2&gt;&quot;</code></pre></figure></p>

<h2>Static routes</h2>

<p>You can define static routes for a particular interface to use with --static-routes. The format of a static route is:</p>

<p><code>
network/CIDR:gateway
</code></p>

<p>So, for example to route the 192.168.1.0/24 network through 192.168.1.254:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler system edit --name=foo --interface=eth0 --static-routes=&quot;192.168.1.0/24:192.168.1.254&quot;</code></pre></figure></p>

<p>As with all lists in cobbler, the --static-routes list is space-separated so you can specify multiple static routes if needed.</p>

<h2>Kickstart Notes</h2>

<p>Three different networking <a href="/manuals/2.6.0/3/6_-_Snippets.html">Snippets</a> must be present in your kickstart files for this to work:</p>

<pre>
pre_install_network_config
network_config
post_install_network_config
</pre>


<p>The default kickstart templates (/var/lib/cobbler/kickstart/sample*.ks) have these installed by default so they work out of the box. Please use those files as a reference as to where to correctly include the $SNIPPET definitions.</p>
