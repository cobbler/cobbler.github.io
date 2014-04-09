---
layout: manpage
title: Fedora
meta: 2.6.0
---


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

And (re)start/enable Apache:

{% highlight bash %}
$ systemctl start httpd.service
$ systemctl enable httpd.service
{% endhighlight %}


