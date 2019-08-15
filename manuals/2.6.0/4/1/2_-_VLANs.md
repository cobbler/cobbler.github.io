
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4_-_Advanced_Topics.html">4</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4/1_-_Advanced_Networking.html">1</a> <span class="divider">/</span></li><li class="active">Advanced Networking - VLANs</li></ul>
   <h1>Advanced Networking - VLANs</h1>
<p>You can now add VLAN tags to interfaces from Cobbler. In this case we have two VLANs on eth0: 10 and 20. The default VLAN (untagged traffic) is not used:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler system edit --name=foo3.bar.local --interface=eth0 --mac=AA:BB:CC:DD:EE:F0 --static=1
$ cobbler system edit --name=foo3.bar.local --interface=eth0.10 --static=1 --ip-address=10.0.10.5 --subnet=255.255.255.0
$ cobbler system edit --name=foo3.bar.local --interface=eth0.20 --static=1 --ip-address=10.0.20.5 --subnet=255.255.255.0</code></pre></figure></p>

<p><strong>NOTE</strong> You must install the vconfig package during the build process for this to work in the %post section of your build.</p>
