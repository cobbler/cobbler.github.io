---
layout: manpage
title: Alternative Storage Backends - MongoDB
meta: 2.2.3
---

## {{ page.title }}

Cobbler 2.2.x introduced support for MongoDB as alternate storage backend, due to the native use of JSON. Currently, support for this backend is BETA-quality, and it should not be used for critical production systems.

### Serializer Setup

Add or modify the following section in the /etc/cobbler/modules.conf configuration file:

{% highlight ini %}
[serializers]
settings = serializer_catalog
distro = serializer_mongodb
profile = serializer_mongodb
system = serializer_mongodb
repo = serializer_mongodb
etc...
{% endhighlight %}

**NOTE** Be sure to leave the settings serializer set to serializer_catalog.

### MongoDB Configuration File

The configuration file for the MongoDB serializer is /etc/cobbler/mongodb.conf. This is an INI-style configuration file, which has the following default entries:

{% highlight ini %}
[connection]
host = localhost
port = 27017
{% endhighlight %}
