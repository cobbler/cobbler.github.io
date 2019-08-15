
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/2_-_Installing_Cobbler.html">2</a> <span class="divider">/</span></li><li class="active">Relocating Your Installation</li></ul>
   <h1>Relocating Your Installation</h1>
<p>Often folks don't have a very large <code>/var</code> partition, which is what cobbler uses by default for mirroring install trees and the like.</p>

<p>You'll notice you can reconfigure the webdir location just by going into <code>/etc/cobbler/settings</code>, but it's not the best way to do things -- especially as the RPM packaging does include some files and directories in the stock path. This means that, for upgrades and the like, you'll be breaking things somewhat. Rather than attempting to reconfigure cobbler, your Apache configuration, your file permissions, and your SELinux rules, the recommended course of action is very simple.</p>

<ol>
<li>Copy everything you have already in <code>/var/www/cobbler</code> to another location -- for instance, <code>/opt/cobbler_data</code></li>
<li>Now just create a symlink or bind mount at <code>/var/www/cobbler</code> that points to <code>/opt/cobbler_data</code>.</li>
</ol>


<p>Done. You're up and running.</p>

<div class="alert alert-block alert-info"><b>Note:</b> If you decided to access cobbler's data store over NFS (not recommended) you really want to mount NFS on <code>/var/www/cobbler</code> with SELinux context passed in as a parameter to mount versus the symlink. You may also have to deal with problems related to rootsquash. However if you are making a mirror of a Cobbler server for a multi-site setup, mounting read only is ok there.</div>




<div class="alert alert-block alert-info"><b>Also Note:</b> <code>/var/lib/cobbler</code> can not live on NFS, as this interferes with locking ("flock") cobbler does around it's storage files.</div>
