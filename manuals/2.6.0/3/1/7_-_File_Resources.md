

<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/3_-_General_Topics.html">3</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/3/1_-_Cobbler_Primitives.html">1</a> <span class="divider">/</span></li><li class="active">File Resources</li></ul>
   <h1>File Resources</h1>
<p>File resources are managed using cobbler file add, allowing you to create and delete files on a system.</p>

<h2>Actions</h2>

<h3>create</h3>

<p>Create the file. [Default]</p>

<h3>remove</h3>

<p>Remove the file.</p>

<h2>Attributes</h2>

<h3>mode</h3>

<p>Permission mode (as in chmod).</p>

<h3>group</h3>

<p>The group owner of the file.</p>

<h3>user</h3>

<p>The user for the file.</p>

<h3>path</h3>

<p>The path for the file.</p>

<h3>template</h3>

<p>The template for the file.</p>

<h4>Example:</h4>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler file add --name=string --comment=string [--action=string] --mode=string --group=string \
--user=string --path=string [--template=string]</code></pre></figure></p>
