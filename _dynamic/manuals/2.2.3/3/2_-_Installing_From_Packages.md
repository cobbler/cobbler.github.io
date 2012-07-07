---
layout: manpage
title: Installing Cobbler From Packages
meta: 2.2.3
---

# {{ page.title }}

Cobbler is available for installation for many Linux variants through their packaging systems.

## Fedora

Cobbler is packaged and available through the Fedora packaging system, so you just need to install the packages with the yum command:

{% highlight bash %}
$ sudo yum install cobbler
{% endhighlight %}

With Fedora's packaging system, new releases are held in a "testing" repository for a period of time to vet bugs. If you would like to install the most up to date version of cobbler for Fedora (which may not be fully vetted for a production environment), enable the -testing repo when installing or updating:

{% highlight bash %}
$ sudo yum install --enablerepo=updates-testing cobbler
# or
$ sudo yum update --enablerepo=updates-testing cobbler
{% endhighlight %}

Once cobbler is installed, start and enable the service:

{% highlight bash %}
$ systemctl start cobblerd.service
$ systemctl enable cobblerd.service
$ systemctl status cobblerd.service
cobblerd.service - Cobbler Helper Daemon
	  Loaded: loaded (/lib/systemd/system/cobblerd.service; enabled)
	  Active: active (running) since Sun, 17 Jun 2012 13:01:28 -0500; 1min 44s ago
	Main PID: 1234 (cobblerd)
	  CGroup: name=systemd:/system/cobblerd.service
		  └ 1234 /usr/bin/python /usr/bin/cobblerd -F
{% endhighlight %}

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

## Debian/Ubuntu

Coming soon.

## SuSE

Coming soon.
