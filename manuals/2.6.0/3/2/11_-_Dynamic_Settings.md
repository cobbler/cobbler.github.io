
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/3_-_General_Topics.html">3</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/3/2_-_Cobbler_Direct_Commands.html">2</a> <span class="divider">/</span></li><li class="active">Dynamic Settings CLI Command</li></ul>
   <h1>Dynamic Settings CLI Command</h1>
<p>The CLI command for dynamic settings has two sub-commands:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler setting --help</p>

<h1>usage</h1>

<p>cobbler setting edit
cobbler setting report</code></pre></figure></p>

<h3>cobbler setting edit</h3>

<p>This command allows you to modify a setting on the fly. It takes affect immediately, however depending on the setting you change, a "cobbler sync" may be required afterwards in order for the change to be fully applied.</p>

<p>This syntax of this command is as follows:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler setting edit --name=option --value=value</code></pre></figure></p>

<p>As with other cobbler primitives, settings that are array-based should be space-separated while hashes should be a space-separated list of key=value pairs.</p>

<h3>cobbler setting report</h3>

<p>This command prints a report of the current settings. The syntax of this command is as follows:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler setting report [--name=option]</code></pre></figure></p>

<p>The list of settings can be limited to a single setting by specifying the --name option.</p>
