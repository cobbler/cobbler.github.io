
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/2_-_Installing_Cobbler.html">2</a> <span class="divider">/</span></li><li class="active">Installing From Source</li></ul>
   <h1>Installing From Source</h1>
<p>Cobbler is licensed under the General Public License (GPL), version 2 or later. You can download it, free of charge, using the links below.</p>

<h2>Latest Source</h2>

<p>The latest source code (it's all Python) is available through <a href="https://github.com/cobbler/cobbler">git</a>.</p>

<h3>Getting the Code</h3>

<p>Clone the repo using git:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ git clone git://github.com/cobbler/cobbler.git</p>

<h1>or</h1>

<p>$ git clone https://github.com/cobbler/cobbler.git</p>

<p>$ cd cobbler
$ git checkout release24</code></pre></figure></p>

<div class="alert alert-info alert-block"><b>Note:</b> The release24 branch corresponds to the official release version for the 2.4.x series. The master branch is the development series, and always uses an odd number for the minor version (for example, 2.5.0).</div>


<h2>Installing</h2>

<p>When building from source, make sure you have the correct <a href="/manuals/2.6.0/2/1_-_Prerequisites.html">Prerequisites for Installation</a>. Once they are, you can install cobbler with the following command:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ make install</code></pre></figure></p>

<p>This command will rewrite all configuration files on your system if you have an existing installation of Cobbler (whether it was installed via packages or from an older source tree). To preserve your existing configuration files, snippets and kickstarts, run this command:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ make devinstall</code></pre></figure></p>

<p>To install the Cobbler web GUI, use this command:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ make webtest</code></pre></figure></p>

<div class="alert alert-info alert-block"><b>Note:</b> This will do a full install, not just the web GUI. "make webtest" is a wrapper around "make devinstall", so your configuration files will also be saved when running this command.</div>


<h3>Building Packages from Source (RPM)</h3>

<p>It is also possible to build packages from the source file. Right now, only RPMs are supported, however we plan to add support for building .deb files in the future as well.</p>

<p>To build RPMs from source, use this command:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ make rpms
... (lots of output) ...
Wrote: /path/to/cobbler/rpm-build/cobbler-2.6.0-1.fc20.src.rpm
Wrote: /path/to/cobbler/rpm-build/cobbler-2.6.0-1.fc20.noarch.rpm
Wrote: /path/to/cobbler/rpm-build/koan-2.6.0-1.fc20.noarch.rpm
Wrote: /path/to/cobbler/rpm-build/cobbler-web-2.6.0-1.fc20.noarch.rpm</code></pre></figure></p>

<p>As you can see, an RPM is output for each component of cobbler, as well as a source RPM. This command was run on a system running Fedora 20, thus the fc20 in the RPM name - this will be different based on the distribution you're running.</p>

<h3>Building Packages from Source (DEB)</h3>

<p>To install cobbler from source on Debian Squeeze, the following steps need to be made:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ apt-get install make # for build
$ apt-get install git # for build
$ apt-get install python-yaml
$ apt-get install python-cheetah
$ apt-get install python-netaddr
$ apt-get install python-simplejson
$ apt-get install python-urlgrabber
$ apt-get install libapache2-mod-wsgi
$ apt-get install python-django
$ apt-get install atftpd</p>

<p>$ a2enmod proxy
$ a2enmod proxy_http
$ a2enmod rewrite</p>

<p>$ a2ensite cobbler.conf</p>

<p>$ ln -s /usr/local/lib/python2.6/dist-packages/cobbler /usr/lib/python2.6/dist-packages/
$ ln -s /srv/tftp /var/lib/tftpboot</p>

<p>$ chown www-data /var/lib/cobbler/webui_sessions</code></pre></figure></p>

<ul>
<li>Change all <code>/var/www/cobbler</code> in <code>/etc/apache2/conf.d/cobbler.conf</code> to <code>/usr/share/cobbler/webroot/</code></li>
<li>init script

<ul>
<li>add Required-Stop line</li>
<li>path needs to be <code>/usr/local/...</code> or fix the install location
</pre></li>
</ul>
</li>
</ul>


<p>The same steps will most likely be required on the current 2.2.x stable branch.</p>
