
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4_-_Advanced_Topics.html">4</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4/3_-_Configuration_Management.html">3</a> <span class="divider">/</span></li><li class="active">Built-In Configuration Management</li></ul>
   <h1>Built-In Configuration Management</h1>
<p>Cobbler is not just an installation server, it can also enable two different types of ongoing configuration management system (CMS):</p>

<ul>
<li>integration with an established external CMS such as <a href="http://cfengine.com/">cfengine3</a> or <a href="http://puppetlabs.com/">puppet</a>, discussed <a href="Using%20cobbler%20with%20a%20configuration%20management%20system">elsewhere</a>;</li>
<li>its own, much simpler, lighter-weight, internal CMS, discussed here.</li>
</ul>


<h2>Setting up</h2>

<p>Cobbler's internal CMS is focused around packages and templated configuration files, and installing these on client systems.</p>

<p>This all works using the same
<a href="http://cheetahtemplate.org">Cheetah-powered</a> templating engine
used in <a href="/cobbler/cobbler/wiki/KickstartTemplating">KickstartTemplating</a>,
so once you learn about the power of treating your distribution
answer files as templates, you can use the same templating to drive
your CMS configuration files.</p>

<p>For example:</p>

<pre><code>cobbler profile edit --name=webserver \
  --template-files=/srv/cobbler/x.template=/etc/foo.conf
</code></pre>

<p>A client system installed via the above profile will gain a file "/etc/foo.conf" which is the result of rendering the template given by "/srv/cobbler/x.template". Multiple files may be specified; each "template=destination" pair should be placed in a space-separated list enclosed in quotes:</p>

<pre><code>--template-files="srv/cobbler/x.template=/etc/xfile.conf srv/cobbler/y.template=/etc/yfile.conf"
</code></pre>

<h2>Template files</h2>

<p>Because the template files will be parsed by the Cheetah parser, they must conform to the guidelines described in <a href="Kickstart%20Templating">Kickstart Templating</a>. This is particularly important when the file is generated outside a Cheetah environment. Look for, and act on, Cheetah 'ParseError' errors in the Cobbler logs.</p>

<p>Template files follows general Cheetah syntax, so can include Cheetah variables. Any variables you define anywhere in the cobbler object hierarchy (distros, profiles, and systems) are available to your templates. To see all the variables available, use the command:</p>

<pre><code>cobbler profile dumpvars --name=webserver
</code></pre>

<p>Cobbler snippets and other advanced features can also be employed.</p>

<h2>Ongoing maintenance</h2>

<p>Koan can pull down files to keep a system updated with the latest templates and variables:</p>

<pre><code>koan --server=cobbler.example.org --profile=foo --update-files
</code></pre>

<p>You could also use <code>--server=bar</code> to retrieve a more specific set of templating.(???) Koan can also autodetect the server if the MAC address is registered.</p>

<h2>Further uses</h2>

<p>This Cobbler/Cheetah templating system can serve up templates via the magic URLs (see "Leveraging Mod Python" below). To do this ensure that the destination path given to any <code>--template-files</code> element is relative, not absolute; then Cobbler and koan won't download those files.</p>

<p>For example, in:</p>

<pre><code>cobbler profile edit --name=foo \
  --template-files="/srv/templates/a.src=/etc/foo/a.conf /srv/templates/b.src=1"
</code></pre>

<p>cobbler and koan would automatically download the rendered "a.src" to replace the file "/etc/foo/a.conf", but the b.src file would not be downloaded to anything because the destination pathname "1" is not absolute.</p>

<p>This technique enables using the Cobbler/Cheetah templating system to build things that other systems can fetch and use, for instance, BIOS config files for usage from a live environment.</p>

<h2>Leveraging Mod Python</h2>

<p>All template files are generated dynamically at run-time. If a change is made to a template, a <code>--ks-meta</code> variable or
some other variable in cobbler, the result of template rendering will be different on subsequent runs. This is covered in more depth in the <a href="Developer%20documentation">Developer documentation</a>.</p>

<h2>Possible future developments</h2>

<ul>
<li>Serving and running scripts via <code>--update-files</code> (probably staging them through "/var/spool/koan").</li>
<li>Auto-detection of the server name if <code>--ip</code> is registered.</li>
</ul>

