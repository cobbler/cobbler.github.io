---
layout: manpage
title: Modules
meta: 2.6.0
nav: 2 - Modules
navversion: nav26
---

<p>Certain cobbler features can be user extended (in Python) by Cobbler users.</p>

<p>These features include storage of data (serialization), authorization, and authentication. Over time, this list of module types will grow to support more options.  <a href="Triggers">Triggers</a> are basically modules.</p>

<h2>See Also</h2>

<ul>
<li><a href="Security%20Overview">Security</a></li>
<li>the cobbler command line itself (it's implemented in cobbler
modules so it's easy to add new commands)</li>
</ul>


<h2>Python Files And modules.conf</h2>

<p>To create a module, add a python file in
<code>/usr/lib/python$version/site-packages/cobbler/modules</code>. Then, in the
apppropriate part of <code>/etc/cobbler/modules.conf</code>, reference the name
of your module so cobbler knows that you want to activate the
module.</p>

<p>(<a href="Triggers">Triggers</a> that are python
modules, as well as CLI python modules don't need to be listed in
this file, they are auto-loaded)</p>

<p>An example from the serializers is:</p>

<pre><code>[serializers]
settings = serializer_catalog
</code></pre>

<p>The format of <code>/etc/cobbler/modules.conf</code> is that of Python's
ConfigParser module.</p>

<pre><code>    A setup file consists of sections, lead by a "[section]" header,
    and followed by "name: value" entries, with continuations and such in
    the style of RFC 822.
</code></pre>

<p>Each module, regardless of it's nature, must have the following
function that returns the type of module (as a string) on an
acceptable load (when the module can be loaded) or raises an
exception otherwise.</p>

<p>The trivial case for a cli module is:</p>

<pre><code>def register():
    return "cli"
</code></pre>

<p>Other than that, modules do not have a particular API signature --
they are "Duck Typed" based on how they are employed. When starting
a new module, look at other modules of the same type to see what
functions they possess.</p>
