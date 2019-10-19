---
layout: manpage
title: Alternative Storage Backends
meta: 2.8.0
nav: 12 - Alternative storage backends
navversion: nav28
---

Cobbler saves object data via serializers implemented as Cobbler [Modules]({% link manuals/2.8.0/4/4/2_-_Modules.md %}).
This means Cobbler can be extended to support other storage backends for those that want to do it. Today, cobbler ships
three such modules alternate backends: MySQL, MongoDB and CouchDB.

The default serializer is **serializer_catalog** which uses JSON in `/var/lib/cobbler/config/\<object\>` directories,
with one file for each object definition. It is very fast, however people with a large number of systems can still
experience slowness, especially if cobbler lives on a disk partition that is slow or heavily utilized. Users with such
setups should ensure `/var/lib/cobbler` is mounted on a dedicated disk that offers higher performance (15K SAS or a SAN
LUN for example).

An older legacy serializer, "serializer_yaml" is deprecated and is only around to support older installs that have not
yet upgraded to serializer_catalog by changing the serializer values in `/etc/cobbler/modules.conf` and restarting
cobblerd.

### Details

Here's what the relavant parts of modules.conf look like:

{% highlight ini %}
[serializers]
settings = serializer_catalog
distro = serializer_catalog
profile = serializer_catalog
system = serializer_catalog
repo = serializer_catalog
etc...
{% endhighlight %}

**NOTE** Be sure to add a line for every object type supported in your version of cobbler. Read the
[Cobbler Primitives]({% link manuals/2.8.0/3/1_-_Cobbler_Primitives.md %}) section for more details.

Suppose, however, that you (just to be contrary), want to save everything in Marshalled XML because you liked angle
brackets a whole lot (we don't!). Easy enough, just write a new serializer module that did this and then could change
the file to:

{% highlight ini %}
[serializers]
settings = serializer_catalog
distro = serializer_xml
profile = serializer_xml
system = serializer_xml
repo = serializer_xml
etc...
{% endhighlight %}

This is all just an example -- in your environment, you may have more complex needs -- or even some weird ones.

Often folks ask about whether we can save and read from LDAP, though currently such a serializer is not implemented,
though we might be interested in it if it was performant enough.

### One Note of Warning

The "settings" serializer should always be "serializer_catalog", or at least should read `/var/lib/cobbler/settings` and
treat it as a YAML file. Don't change it unless you know what you are doing, as that file (in YAML format) is packaged
as part of the Cobbler RPM.

Future versions of Cobbler may change this default, and revert to using the YAML config only if no JSON config is found.

### Notes on serializer_catalog

Serializer catalog will save individual files in:

{% highlight bash %}
/var/lib/cobbler/config/distros.d
/var/lib/cobbler/config/profiles.d
/var/lib/cobbler/config/systems.d
etc...
{% endhighlight %}

Files are named after the name of each object, for instance:

{% highlight bash %}
/var/lib/cobbler/config/systems.d/foo.json
{% endhighlight %}

On EL 4 and before, the simplejson implementation has some unicode issues, so YAML is still the default on those
systems. YAML is significantly slower, so this is more reason to install Cobbler on EL 5 and later. (Or rather, json is
300x faster!)

The filenames for YAML files do not have an extension.

{% highlight bash %}
/var/lib/cobbler/config/systems.d/foo
{% endhighlight %}

Cobbler knows how to upgrade YAML files to JSON if it is running on a platform that can use JSON, and will do so
transparently.
