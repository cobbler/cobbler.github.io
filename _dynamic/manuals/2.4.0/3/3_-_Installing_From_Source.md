---
layout: manpage
title: Installing From Source
meta: 2.4.0
---

Cobbler is licensed under the General Public License (GPL), version 2 or later. You can download it, free of charge, using the links below.

## Latest Source

The latest source code (it's all Python) is available through [git](https://github.com/cobbler/cobbler).

### Getting the Code

Clone the repo using git:

{% highlight bash %}
$ git clone git://github.com/cobbler/cobbler.git
# or
$ git clone https://github.com/cobbler/cobbler.git

$ cd cobbler
$ git checkout release24
{% endhighlight %}

<div class="alert alert-info alert-block"><b>Note:</b> The release24 branch corresponds to the official release version for the 2.4.x series. The master branch is the development series, and always uses an odd number for the minor version (for example, 2.5.0).</div>

## Installing

When building from source, make sure you have the correct {% linkup title:"Prerequisites for Installation" extrameta:2.4.0 %}. Once they are, you can install cobbler with the following command:

{% highlight bash %}
$ make install
{% endhighlight %}

This command will rewrite all configuration files on your system if you have an existing installation of Cobbler (whether it was installed via packages or from an older source tree). To preserve your existing configuration files, snippets and kickstarts, run this command:

{% highlight bash %}
$ make devinstall
{% endhighlight %}

To install the Cobbler web GUI, use this command:

{% highlight bash %}
$ make webtest
{% endhighlight %}

<div class="alert alert-info alert-block"><b>Note:</b> This will do a full install, not just the web GUI. "make webtest" is a wrapper around "make devinstall", so your configuration files will also be saved when running this command.</div>

### Building Packages from Source

It is also possible to build packages from the source file. Right now, only RPMs are supported, however we plan to add support for building .deb files in the future as well.

To build RPMs from source, use this command:

{% highlight bash %}
$ make rpms
... (lots of output) ...
Wrote: /path/to/cobbler/rpm-build/cobbler-2.4.0-1.fc17.src.rpm
Wrote: /path/to/cobbler/rpm-build/cobbler-2.4.0-1.fc17.noarch.rpm
Wrote: /path/to/cobbler/rpm-build/koan-2.4.0-1.fc17.noarch.rpm
Wrote: /path/to/cobbler/rpm-build/cobbler-web-2.4.0-1.fc17.noarch.rpm
{% endhighlight %}

As you can see, an RPM is output for each component of cobbler, as well as a source RPM. This command was run on a system running Fedora 17, thus the fc17 in the RPM name - this will be different based on the distribution you're running.
