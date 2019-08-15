
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4_-_Advanced_Topics.html">4</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4/12_-_Alternative_Storage_Backends.html">12</a> <span class="divider">/</span></li><li class="active">Alternative Storage Backends - CouchDB</li></ul>
   <h1>Alternative Storage Backends - CouchDB</h1>
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
