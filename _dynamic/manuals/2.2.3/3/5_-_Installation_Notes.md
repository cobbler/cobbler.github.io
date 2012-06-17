---
layout: manpage
title: Cobbler Manual - Installation Notes
meta: 2.2.3
---
# Installation Notes
The purpose of this page is to document installation requirements (especially when installing from source) on distros that don't have official packaging or for those that want the most up to date version of cobbler.

## Debian Squeeze (2.3.0 devel tested on 6.0.4)

To install cobbler from source on Debian Squeeze, the following steps need to be made:

{% highlight bash %}
$ apt-get install make # for build
$ apt-get install git # for build
$ apt-get install python-yaml
$ apt-get install python-cheetah
$ apt-get install python-netaddr
$ apt-get install python-simplejson
$ apt-get install python-urlgrabber
$ apt-get install libapache2-mod-wsgi
$ apt-get install python-django
$ apt-get install atftpd

$ a2enmod proxy
$ a2enmod proxy_http
$ a2enmod rewrite

$ ln -s /usr/local/lib/python2.6/dist-packages/cobbler /usr/lib/python2.6/dist-packages/
$ ln -s /srv/tftp /var/lib/tftpboot

$ chown www-data /var/lib/cobbler/webui_sessions
{% endhighlight %}

* Change all /var/www/cobbler in /etc/apache2/conf.d/cobbler.conf to /usr/share/cobbler/webroot/
* init script
  - add Required-Stop line
  - path needs to be /usr/local/... or fix the install location
</pre>

The same steps will most likely be required on the current 2.2.x stable branch.
