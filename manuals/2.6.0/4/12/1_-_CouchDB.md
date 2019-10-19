---
layout: manpage
title: Alternative Storage Backends - CouchDB
meta: 2.6.0
nav: 1 - CouchDB
navversion: nav26
---

<p>Cobbler 2.0.x introduced support for CouchDB as alternate storage backend, primarily as a proof of concept for NoSQL style databases. Currently, support for this backend is ALPHA-quality as it has not received significant testing.</p>

<p>Currently, CouchDB must be configured and running on the same system as the cobblerd daemon in order for Cobbler to connect to it successfully. Additional SELinux rules may be required for this connection if SELinux is set to enforcing mode.</p>

<h3>Serializer Setup</h3>

<p>Add or modify the following section in the <code>/etc/cobbler/modules.conf</code> configuration file:</p>

<p><figure class="highlight"><pre><code class="language-ini" data-lang="ini">[serializers]
settings = serializer_catalog
distro = serializer_couchdb
profile = serializer_couchdb
system = serializer_couchdb
repo = serializer_couchdb
etc...</code></pre></figure></p>

<p><strong>NOTE</strong> Be sure to leave the settings serializer set to serializer_catalog.</p>
