
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4_-_Advanced_Topics.html">4</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4/1_-_Advanced_Networking.html">1</a> <span class="divider">/</span></li><li class="active">Advanced Networking - Bridging</li></ul>
   <h1>Advanced Networking - Bridging</h1>
<p>A bridge is a way to connect two Ethernet segments together in a protocol independent way. Packets are forwarded based on Ethernet address, rather than IP address (like a router). Since forwarding is done at Layer 2, all protocols can go transparently through a bridge. (<a href="http://www.linuxfoundation.org/collaborate/workgroups/networking/bridge">reference</a>).</p>

<p>You can create a bridge in cobbler in the following way:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler system edit --name=foo --interface=eth0 --mac=AA:BB:CC:DD:EE:F0 --interface-type=bridge_slave --interface-master=br0
$ cobbler system edit --name=foo --interface=eth1 --mac=AA:BB:CC:DD:EE:F1 --interface-type=bridge_slave --interface-master=br0
$ cobbler system edit --name=foo --interface=br0 --interface-type=bridge --bridge-opts=&quot;stp=no&quot; --ip-address=192.168.1.100 --netmask=255.255.255.0</code></pre></figure></p>

<p>You can specify any bridging options you would like, so please read the brctl manpage for details if you are unfamiliar with bridging.</p>

<p><strong>NOTE</strong> You must install the bridge-utils package during the build process for this to work in the %post section of your build.</p>
