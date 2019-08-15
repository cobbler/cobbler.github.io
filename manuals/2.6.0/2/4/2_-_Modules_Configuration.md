
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/2_-_Installing_Cobbler.html">2</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/2/4_-_Configuration_Files.html">4</a> <span class="divider">/</span></li><li class="active">Modules Configuration</li></ul>
   <h1>Modules Configuration</h1>
<p>Cobbler supports add-on modules, some of which can provide the same functionality (for instance, the authentication/authorization modules discussed in the <a href="/manuals/2.6.0/5/2_-_Web_Authentication.html">Web Authentication</a> section). Modules of this nature are configured via the <code>/etc/cobbler/modules.conf file</code>, for example:</p>

<p><figure class="highlight"><pre><code class="language-ini" data-lang="ini"># dns:</p>

<h1>chooses the DNS management engine if manage_dns is enabled</h1>

<h1>in /etc/cobbler/settings, which is off by default.</h1>

<h1>choices:</h1>

<h1>manage_bind    -- default, uses BIND/named</h1>

<h1>manage_dnsmasq -- uses dnsmasq, also must select dnsmasq for dhcp below</h1>

<p>[dns]
module = manage_bind</code></pre></figure></p>

<p>As you can see above, this file has a typical INI-style syntax where sections are denoted with the <strong>[]</strong> brackets and entries are of the form <strong>"key = value"</strong>.</p>

<p>Many of these sections are covered in the <a href="/manuals/2.6.0/3/4_-_Managing_Services_With_Cobbler.html">Managing Services With Cobbler</a> and <a href="/manuals/2.6.0/5/2_-_Web_Authentication.html">Web Authentication</a> topics later in this manual. Please refer to those sections for further details on modifying this file.</p>

<p>As with the settings file, you must restart cobblerd after making changes to this file.</p>
