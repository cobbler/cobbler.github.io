

<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/2_-_Installing_Cobbler.html">2</a> <span class="divider">/</span></li><li class="active">Prerequisites for Installation</li></ul>
   <h1>Prerequisites for Installation</h1>
<p>Cobbler has both definite and optional prerequisites, based on the features you'd like to use. This section documents the definite prerequisites for both a basic installation and when building/installing from source. Please see the <a href="/manuals/2.6.0/3/4_-_Managing_Services_With_Cobbler.html">Managing Services With Cobbler</a> section for details on the prerequisites for managing services, and other sections may make note of other package requirements.</p>

<p>Please note that installing any of the packages here via a package manager (such as yum or apt) can and will require a large number of ancilary packages, which we do not document here. The package definition should automatically pull these packages in and install them along with cobbler, however it is always best to verify these requirements have been met prior to installing cobbler or any of its components.</p>

<h2>Cobbler/Cobblerd</h2>

<p>First and foremost, cobbler requires Python. Any version over 2.6 should work. Cobbler also requires the installation of the following packages:</p>

<ul>
<li>createrepo</li>
<li>httpd (apache2 for Debian/Ubuntu)</li>
<li>mkisofs</li>
<li>mod_wsgi (libapache2-mod-wsgi for Debian/Ubuntu)</li>
<li>mod_ssl (libapache2-mod-ssl)</li>
<li>python-cheetah</li>
<li>python-netaddr</li>
<li>python-simplejson</li>
<li>python-urlgrabber</li>
<li>PyYAML (python-yaml for Debian/Ubuntu)</li>
<li>rsync</li>
<li>syslinux</li>
<li>tftp-server (atftpd for Debian/Ubuntu, though others <em>may</em> work)</li>
<li>yum-utils</li>
</ul>


<h2>Cobbler-Web</h2>

<p>Cobbler web only has one other requirement besides cobbler itself:</p>

<ul>
<li>Django (python-django for Debian/Ubuntu)</li>
</ul>


<h2>Koan</h2>

<p>Koan can be installed apart from cobblerd, and has only the following requirement (besides python itself of course):</p>

<ul>
<li>python-simplejson</li>
</ul>


<h2>Source Prerequisites</h2>

<p>Installation from source requires the following additional packages:</p>

<ul>
<li>git</li>
<li>make</li>
<li>python-devel</li>
<li>python-setuptools</li>
<li>python-cheetah</li>
<li>openssl</li>
</ul>

