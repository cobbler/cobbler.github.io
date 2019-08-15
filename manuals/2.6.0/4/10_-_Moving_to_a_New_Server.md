
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4_-_Advanced_Topics.html">4</a> <span class="divider">/</span></li><li class="active">Cobbler Manual</li></ul>
   <h1>Cobbler Manual</h1>
<h2>About</h2>

<p>What if you have Cobbler installed on Box A, and decide it really
needs to be on Box B? Without doing everything from scratch again,
how would you accomplish the move? (Some of these instructions may
also be useful for backing up a cobbler install as well).</p>

<h2>Suggested Process</h2>

<ol>
<li><p>Install Cobbler on the new system.</p></li>
<li><p>on the new box, run "cobbler replicate". See
<a href="Replication">Replication</a> for instructions
and make sure you use the right flags to transfer scripts and
data.</p></li>
<li><p>Try installing some systems to make sure everything works like you
would expect.</p></li>
</ol>
