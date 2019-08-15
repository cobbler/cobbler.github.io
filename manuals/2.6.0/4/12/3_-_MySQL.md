
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4_-_Advanced_Topics.html">4</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4/12_-_Alternative_Storage_Backends.html">12</a> <span class="divider">/</span></li><li class="active">Alternative Storage Backends - MySQL</li></ul>
   <h1>Alternative Storage Backends - MySQL</h1>
<p>Cobbler 2.4.0 introduced support for MySQL as alternate storage backend. Currently, support for this backend is ALPHA-quality, and it should not be used for critical production systems.</p>

<h3>Serializer Setup</h3>

<p>Add or modify the following section in the <code>/etc/cobbler/modules.conf</code> configuration file:</p>

<p><figure class="highlight"><pre><code class="language-ini" data-lang="ini">[serializers]
settings = serializer_catalog
distro = serializer_mysql
profile = serializer_mysql
system = serializer_mysql
repo = serializer_mysql
etc...</code></pre></figure></p>

<p><strong>NOTE</strong> Be sure to leave the settings serializer set to serializer_catalog.</p>

<h3>MySQL Schema</h3>

<p>The schema for the cobbler database is very simple, and essentially uses MySQL as a key/value store with a TEXT field storing the JSON for each object. The schema is as follows:</p>

<p><figure class="highlight"><pre><code class="language-sql" data-lang="sql">CREATE DATABASE cobbler;
GRANT ALL PRIVILEGES ON cobbler.* TO &#39;cobbler&#39;@&#39;%&#39; IDENTIFIED BY &#39;testing123&#39;;
CREATE TABLE distro (name VARCHAR(100) NOT NULL PRIMARY KEY, data TEXT) ENGINE=innodb;
CREATE TABLE profile (name VARCHAR(100) NOT NULL PRIMARY KEY, data TEXT) ENGINE=innodb;
CREATE TABLE system (name VARCHAR(100) NOT NULL PRIMARY KEY, data TEXT) ENGINE=innodb;
CREATE TABLE image (name VARCHAR(100) NOT NULL PRIMARY KEY, data TEXT) ENGINE=innodb;
CREATE TABLE repo (name VARCHAR(100) NOT NULL PRIMARY KEY, data TEXT) ENGINE=innodb;
CREATE TABLE mgmtclass (name VARCHAR(100) NOT NULL PRIMARY KEY, data TEXT) ENGINE=innodb;
CREATE TABLE file (name VARCHAR(100) NOT NULL PRIMARY KEY, data TEXT) ENGINE=innodb;
CREATE TABLE package (name VARCHAR(100) NOT NULL PRIMARY KEY, data TEXT) ENGINE=innodb;</code></pre></figure></p>

<h3>MySQL Configuration File</h3>

<p>This serializer does not yet have a configuration file, and unfortunately still hard-codes certain database values in the cobbler/modules/serializer_mysql.py file. If you modify the privileges or database name in the schema above, you must edit the .py module as well (be sure to remove the .pyo/.pyc files for that modules) and restart cobblerd.</p>
