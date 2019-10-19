---
layout: manpage
title: Moving to a new Server
meta: 2.6.0
nav: 10 - Moving to a new server
navversion: nav26
---

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
