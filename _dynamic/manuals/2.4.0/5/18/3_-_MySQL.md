---
layout: manpage
title: Alternative Storage Backends - MySQL
meta: 2.4.0
---

Cobbler 2.4.0 introduced support for MySQL as alternate storage backend. Currently, support for this backend is ALPHA-quality, and it should not be used for critical production systems.

### Serializer Setup

Add or modify the following section in the /etc/cobbler/modules.conf configuration file:

{% highlight ini %}
[serializers]
settings = serializer_catalog
distro = serializer_mysql
profile = serializer_mysql
system = serializer_mysql
repo = serializer_mysql
etc...
{% endhighlight %}

**NOTE** Be sure to leave the settings serializer set to serializer_catalog.

### MySQL Schema

The schema for the cobbler database is very simple, and essentially uses MySQL as a key/value store with a TEXT field storing the JSON for each object. The schema is as follows:

{% highlight sql %}
CREATE DATABASE cobbler;
GRANT ALL PRIVILEGES ON cobbler.* TO 'cobbler'@'%' IDENTIFIED BY 'testing123';
CREATE TABLE distro (name VARCHAR(100) NOT NULL PRIMARY KEY, data TEXT) ENGINE=innodb;
CREATE TABLE profile (name VARCHAR(100) NOT NULL PRIMARY KEY, data TEXT) ENGINE=innodb;
CREATE TABLE system (name VARCHAR(100) NOT NULL PRIMARY KEY, data TEXT) ENGINE=innodb;
CREATE TABLE image (name VARCHAR(100) NOT NULL PRIMARY KEY, data TEXT) ENGINE=innodb;
CREATE TABLE repo (name VARCHAR(100) NOT NULL PRIMARY KEY, data TEXT) ENGINE=innodb;
CREATE TABLE mgmtclass (name VARCHAR(100) NOT NULL PRIMARY KEY, data TEXT) ENGINE=innodb;
CREATE TABLE file (name VARCHAR(100) NOT NULL PRIMARY KEY, data TEXT) ENGINE=innodb;
CREATE TABLE package (name VARCHAR(100) NOT NULL PRIMARY KEY, data TEXT) ENGINE=innodb;
{% endhighlight %}

### MySQL Configuration File

This serializer does not yet have a configuration file, and unfortunately still hard-codes certain database values in the cobbler/modules/serializer_mysql.py file. If you modify the privileges or database name in the schema above, you must edit the .py module as well (be sure to remove the .pyo/.pyc files for that modules) and restart cobblerd.
