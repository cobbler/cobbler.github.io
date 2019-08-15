
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/3_-_General_Topics.html">3</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/3/1_-_Cobbler_Primitives.html">1</a> <span class="divider">/</span></li><li class="active">Package Resources</li></ul>
   <h1>Package Resources</h1>
<p>Package resources are managed using cobbler package add, allowing you to install and uninstall packages on a system outside of your install process.</p>

<h2>Actions</h2>

<h3>install</h3>

<p>Install the package. [Default]</p>

<h3>uninstall</h3>

<p>Uninstall the package.</p>

<h2>Attributes</h2>

<h3>installer</h3>

<p>Which package manager to use, vaild options [rpm|yum].</p>

<h3>version</h3>

<p>Which version of the package to install.</p>

<h4>Example:</h4>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler package add --name=string --comment=string [--action=install|uninstall] --installer=string \
[--version=string]</code></pre></figure></p>
