

<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/3_-_General_Topics.html">3</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/3/2_-_Cobbler_Direct_Commands.html">2</a> <span class="divider">/</span></li><li class="active">Build ISO</li></ul>
   <h1>Build ISO</h1>
<p>Often an environment cannot support PXE because of either (A) an
unfortunate lack of control over DHCP configurations (i.e. another
group owns DHCP and won't give you a next-server entry), or (B) you
are using static IPs only.</p>

<p>This is easily solved:</p>

<pre><code># cobbler buildiso
</code></pre>

<p>What this command does is to copy all distro kernel/initrds onto a
boot CD image and generate a menu for the ISO that is essentially
equivalent to the PXE menu provided to net-installing machines via
Cobbler.</p>

<p>By default, the boot CD menu will include all profiles and systems,
you can force it to display a list of profiles/systems in concern
with the following.</p>

<p>Cobbler versions >= 2.2.0:</p>

<pre><code># cobbler buildiso --systems="system1 system2 system3"
# cobbler buildiso --profiles="profile1 profile2 profile3"
</code></pre>

<p>Cobbler versions &lt; 2.2.0:</p>

<pre><code># cobbler buildiso --systems="system1,system2,system3"
# cobbler buildiso --profiles="profile1,profile2,profile3"
</code></pre>

<p>If you need to install into a lab (or other environment) that does not have network
access to the cobbler server, you can also copy a full distribution tree plus profile
and system records onto a disk image:</p>

<pre><code># cobbler buildiso --standalone --distro="distro1"
</code></pre>
