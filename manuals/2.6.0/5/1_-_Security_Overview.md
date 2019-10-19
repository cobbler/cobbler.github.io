---
layout: manpage
title: Security Overview
meta: 2.6.0
nav: 1 - Security Overview
navversion: nav26
---

<p>This section provides an overview of Cobbler's security model for the Web UI.</p>

<h2>Why Customizable Security?</h2>

<p>See also <a href="Cobbler%20web%20interface">Cobbler Web Interface</a>.</p>

<p>When manipulating cobbler remotely, either through the Web UI or
the XMLRPC interface, different classes of users want different
authentication systems and different workflows. It would be wrong
for Cobbler to enforce any specific workflow on someone moving to
Cobbler from their current systems, as it would limit where Cobbler
can be deployed. So what Cobbler does is make authentication and
authorization extremely pluggable, while still shipping with some
very reasonable defaults.</p>

<p>The center of all of this revolves around a few settings in
<code>/etc/cobbler/modules.conf</code>, for example:</p>

<pre><code>[authentication]
module = authn_configfile

[authorization]
module = authn_allowall
</code></pre>

<p>The list of choices for each option is covered in depth at the
links below.</p>

<h2>Authentication</h2>

<p>The authentication setting determines what external source users
are checked against to see if their passwords are valid.</p>

<p>See
<a href="Web%20Authentication">Authentication</a>.</p>

<p>The default setting is to deny XMLRPC access, so all users wanting
remote/web access will need to pick their authentication mode.</p>

<h2>Authorization</h2>

<p>The authorization setting determines, for a user that has already
passed authentication stages, what resources they have access to in
Cobbler.</p>

<p>See
<a href="Web%20Authorization">Authorization</a>.</p>

<p>The default is to authorize all users that have cleared the
authentication stage.</p>
