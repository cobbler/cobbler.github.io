
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4_-_Advanced_Topics.html">4</a> <span class="divider">/</span></li><li class="active">Cobbler Manual</li></ul>
   <h1>Cobbler Manual</h1>
<h2>Batch Editing</h2>

<p>Do you want to apply a change to a lot of cobbler objects at once?</p>

<p>Try using xargs combined with "cobbler list" commands, such as:</p>

<pre><code>cobbler profile list | xargs -n1 --replace cobbler profile edit --virt-bridge=xenbr1 --name={} 
</code></pre>

<p>The above example sets the virtual bridge used by every cobbler
profile to 'xenbr1'.</p>

<p>You can filter the profile list by sticking a "grep" commmand in
there as a pipe before the xargs.</p>

<p>See also <a href="Command%20Line%20Search">Command Line Search</a></p>
