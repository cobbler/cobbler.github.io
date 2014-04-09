---
layout: manpage
title: Red Hat Entperise Linux
meta: 2.6.0
---


## RHEL/CentOS/Scientific Linux

Cobbler is packaged for RHEL variants through the [Fedora EPEL](http://fedoraproject.org/wiki/EPEL) (Extra Packages for Enterprise Linux) system. Follow the directions there to install the correct repo RPM for your RHEL version and architecture. For example, on for a RHEL6.x x86_64 system:

{% highlight bash %}
$ sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-X-Y.noarch.rpm
{% endhighlight %}

Be sure to use the most recent X.Y version of the epel-release package.

Once that is complete, simply use the yum command to install the cobbler package:

{% highlight bash %}
$ sudo yum install cobbler
{% endhighlight %}

As noted above, new releases in the Fedora packaging system are held in a "testing" repository for a period of time to vet bugs. If you would like to install the most up to date version of cobbler through EPEL (which may not be fully vetted for a production environment), enable the -testing repo when installing or updating:

{% highlight bash %}
$ sudo yum install --enablerepo=epel-testing cobbler
# or
$ sudo yum update --enablerepo=epel-testing cobbler
{% endhighlight %}

Once cobbler is installed, start and enable the service:

{% highlight bash %}
$ service cobblerd start
$ chkconfig cobblerd on
{% endhighlight %}

And (re)start/enable Apache:

{% highlight bash %}
$ service httpd start
$ service cobblerd on
{% endhighlight %}


