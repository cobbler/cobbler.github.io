
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4_-_Advanced_Topics.html">4</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4/12_-_Alternative_Storage_Backends.html">12</a> <span class="divider">/</span></li><li class="active">Alternative Storage Backends - MongoDB</li></ul>
   <h1>Alternative Storage Backends - MongoDB</h1>
<p>Cobbler 2.2.x introduced support for MongoDB as alternate storage backend, due to the native use of JSON. Currently, support for this backend is BETA-quality, and it should not be used for critical production systems.</p>

<h3>Serializer Setup</h3>

<p>Add or modify the following section in the <code>/etc/cobbler/modules.conf</code> configuration file:</p>

<p><figure class="highlight"><pre><code class="language-ini" data-lang="ini">[serializers]
settings = serializer_catalog
distro = serializer_mongodb
profile = serializer_mongodb
system = serializer_mongodb
repo = serializer_mongodb
etc...</code></pre></figure></p>

<p><strong>NOTE</strong> Be sure to leave the settings serializer set to serializer_catalog.</p>

<h3>MongoDB Configuration File</h3>

<p>The configuration file for the MongoDB serializer is <code>/etc/cobbler/mongodb.conf</code>. This is an INI-style configuration file, which has the following default entries:</p>

<p><figure class="highlight"><pre><code class="language-ini" data-lang="ini">[connection]
host = localhost
port = 27017</code></pre></figure></p>
