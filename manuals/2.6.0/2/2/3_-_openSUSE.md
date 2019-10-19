---
layout: manpage
title: openSUSE
meta: 2.6.0
---

Enabled require apache modules (/etc/sysconfig/apache2:APACHE_MODULES)

{% highlight bash %}
/usr/sbin/a2enmod proxy
/usr/sbin/a2enmod proxy_http
/usr/sbin/a2enmod proxy_connect
/usr/sbin/a2enmod rewrite
/usr/sbin/a2enmod ssl
/usr/sbin/a2enmod wsgi
/usr/sbin/a2enmod version
/usr/sbin/a2enmod socache_shmcb (or whatever module you are using)
{% endhighlight %}

Setup SSL certificates in Apache (not documented here)

Enable required apache flag (/etc/sysconfig/apache2:APACHE_SERVER_FLAGS): `/usr/sbin/a2enflag SSL`

Make sure port 80 & 443 are opened in SuSEFirewall2 (not documented here)

Start/enable the apache2 and cobblerd services

{% highlight bash %}
systemctl enable apache2.service
systemctl enable cobblerd.service
systemctl start apache2.service
systemctl start cobblerd.service
{% endhighlight %}

Visit https://${CERTIFICATE_FQDN}/cobbler_web/
