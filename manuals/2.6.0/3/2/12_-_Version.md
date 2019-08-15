
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/3_-_General_Topics.html">3</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/3/2_-_Cobbler_Direct_Commands.html">2</a> <span class="divider">/</span></li><li class="active">Cobbler Version</li></ul>
   <h1>Cobbler Version</h1>
<p>The Cobbler version command is very simple, and provides a little more detailed information about your installation.</p>

<p><strong>Example:</strong></p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler version
Cobbler 2.4.0
  source: ?, ?
  build time: Sun Nov 25 11:45:24 2012</code></pre></figure></p>

<p>The first piece of information is the version. The second line includes information regarding the associated commit for this version. In official releases, this should correspond to the commit for which the build was tagged in git. The final line is the build time, which could be the time the RPM was built, or when the "make" command was run when installing from source.</p>

<p>All of this information is useful when asking for help, so be sure to provide it when opening trouble tickets.</p>
