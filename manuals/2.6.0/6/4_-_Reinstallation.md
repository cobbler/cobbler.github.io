
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/6_-_Koan.html">6</a> <span class="divider">/</span></li><li class="active">Cobbler Manual</li></ul>
   <h1>Cobbler Manual</h1>
<p>Cobbler's helper program, koan, can be installed on remote systems.</p>

<p>It can then be used to reinstall systems, as well as it's original purpose of installing virtual machines.</p>

<p>Usage is as follows:</p>

<pre><code>koan --server cobbler.example.com --profile profileName
koan --server cobbler.example.com --system systemName
</code></pre>

<p>Koan will then configure the bootloader to reinstall the system at next boot.  This can also be used for OS upgrades with an upgrade kickstart as opposed to a kickstart that specifies a clean install.</p>
