---
layout: manpage
title: Cobbler Version
meta: 2.8.0
nav: 12 - Version
navversion: nav28
---

The Cobbler version command is very simple, and provides a little more detailed information about your installation.

**Example:**

{% highlight bash %}
$ cobbler version
Cobbler 2.4.0
  source: ?, ?
  build time: Sun Nov 25 11:45:24 2012
{% endhighlight %}

The first piece of information is the version. The second line includes information regarding the associated commit for
this version. In official releases, this should correspond to the commit for which the build was tagged in git. The
final line is the build time, which could be the time the RPM was built, or when the "make" command was run when
installing from source.

All of this information is useful when asking for help, so be sure to provide it when opening trouble tickets.
