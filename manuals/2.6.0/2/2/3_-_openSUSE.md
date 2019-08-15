---
layout: manpage
title: openSUSE
meta: 2.6.0
---

Enabled require apache modules (/etc/sysconfig/apache2:APACHE_MODULES)

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">/usr/sbin/a2enmod proxy
/usr/sbin/a2enmod proxy_http
/usr/sbin/a2enmod proxy_connect
/usr/sbin/a2enmod rewrite
/usr/sbin/a2enmod ssl
/usr/sbin/a2enmod wsgi
/usr/sbin/a2enmod version
/usr/sbin/a2enmod socache_shmcb (or whatever module you are using)</code></pre></figure></p>

<p>Setup SSL certificates in Apache (not documented here)</p>

<p>Enable required apache flag (/etc/sysconfig/apache2:APACHE_SERVER_FLAGS)</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">/usr/sbin/a2enflag SSL</code></pre></figure></p>

<p>Make sure port 80 &amp; 443 are opened in SuSEFirewall2 (not documented here)</p>

<p>Start/enable the apache2 and cobblerd services</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">systemctl enable apache2.service
systemctl enable cobblerd.service
systemctl start apache2.service
systemctl start cobblerd.service</code></pre></figure></p>

<p>Visit https://${CERTIFICATE_FQDN}/cobbler_web/</p>
