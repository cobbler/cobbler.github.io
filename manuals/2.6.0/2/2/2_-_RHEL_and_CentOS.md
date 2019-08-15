
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/2_-_Installing_Cobbler.html">2</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/2/2_-_Installing_From_Packages.html">2</a> <span class="divider">/</span></li><li class="active">Red Hat Entperise Linux</li></ul>
   <h1>Red Hat Entperise Linux</h1>
<p>Cobbler is packaged for RHEL variants through the <a href="http://fedoraproject.org/wiki/EPEL">Fedora EPEL</a> (Extra Packages for Enterprise Linux) system. Follow the directions there to install the correct repo RPM for your RHEL version and architecture. For example, on for a RHEL6.x x86_64 system:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-X-Y.noarch.rpm</code></pre></figure></p>

<p>Be sure to use the most recent X.Y version of the epel-release package.</p>

<p>Once that is complete, simply use the yum command to install the cobbler package:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ sudo yum install cobbler</code></pre></figure></p>

<p>As noted above, new releases in the Fedora packaging system are held in a "testing" repository for a period of time to vet bugs. If you would like to install the most up to date version of cobbler through EPEL (which may not be fully vetted for a production environment), enable the -testing repo when installing or updating:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ sudo yum install --enablerepo=epel-testing cobbler</p>

<h1>or</h1>

<p>$ sudo yum update --enablerepo=epel-testing cobbler</code></pre></figure></p>

<p>Once cobbler is installed, start and enable the service:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ service cobblerd start
$ chkconfig cobblerd on</code></pre></figure></p>

<p>And (re)start/enable Apache:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ service httpd start
$ service cobblerd on</code></pre></figure></p>
