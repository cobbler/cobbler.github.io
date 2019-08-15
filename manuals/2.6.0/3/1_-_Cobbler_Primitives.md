<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/3_-_General_Topics.html">3</a> <span class="divider">/</span></li><li class="active">Cobbler Primitives</li></ul>
   <h1>Cobbler Primitives</h1>
<p>Primitives are the building blocks Cobbler uses to represent builds, as outlined in the "How We Model Things" section of the <a href="/manuals/2.6.0/1_-_About_Cobbler.html">Introduction to Cobbler</a> page. These objects are generally loosely related, though the distro/profile/system relation is somewhat more strict.</p>

<p>This section covers the creation and use of these objects, as well as how they relate to each other - including the methodology by which attributes are inherited from parent objects.</p>

<h2>Standard Rules</h2>

<p>Cobbler has a standard set of rules for manipulating primitive field values and, in the case of distros/profiles/systems, how those values are inherited from parents to children.</p>

<h3>Inheritance of Values</h3>

<p>Inheritance of values is based on the field type.</p>

<ul>
<li>For regular fields and arrays, the value will only be inherited if the field is set to '&lt;&lt;inherit&gt;&gt;'. Since distros and other objects like repos do not have a parent, these values are inherited from the defaults in <a href="/manuals/2.6.0/3/3_-_Cobbler_Settings.html">Cobbler Settings</a>. If the field is specifically set to an empty string, no value will be inherited.</li>
<li>For hashes, the values from the parent will always be inherited and blended with the child values. If the parent and child have the same key, the child's values will win an override the parent's.</li>
</ul>


<h3>Array Fields</h3>

<p>Some fields in Cobbler (for example, the --name-servers field) are stored as arrays. These arrays are always considered arrays of strings, and are always specified in Cobbler as a space-separated list when using add/edit.</p>

<p><strong>Example:</strong></p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler [object] edit --name=foo --field=&quot;a b c d&quot;</code></pre></figure></p>

<h3>Hash Fields (key=value)</h3>

<p>Other fields in Cobbler (for example, the --ksmeta field) are stored as hashes - that is a list of key=value pairs. As with arrays, both the keys and values are always interpreted as strings.</p>

<h4>Preserving Values When Editing</h4>

<p>By default, any time a hash field is manipulated during an edit, the contents of the field are replaced completely with the new values specified during the edit.</p>

<p><strong>Example:</strong></p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler distro edit --name=foo --ksmeta=&quot;a=b c=d&quot;
$ cobbler distro report --name=foo | grep &quot;Kickstart Meta&quot;
Kickstart Metadata             : {&#39;a&#39;: &#39;b&#39;, &#39;c&#39;: &#39;d&#39;}
$ cobbler distro edit --name=foo --ksmeta=&quot;e=f&quot;
$ cobbler distro report --name=foo | grep &quot;Kickstart Meta&quot;
Kickstart Metadata             : {&#39;e&#39;: &#39;f&#39;}</code></pre></figure></p>

<p>To preserve the contents of these fields, --in-place should be specified:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler distro edit --name=foo --ksmeta=&quot;a=b c=d&quot;
$ cobbler distro report --name=foo | grep &quot;Kickstart Meta&quot;
Kickstart Metadata             : {&#39;a&#39;: &#39;b&#39;, &#39;c&#39;: &#39;d&#39;}
$ cobbler distro edit --name=foo --in-place --ksmeta=&quot;e=f&quot;
$ cobbler distro report --name=foo | grep &quot;Kickstart Meta&quot;
Kickstart Metadata             : {&#39;a&#39;: &#39;b&#39;, &#39;c&#39;: &#39;d&#39;, &#39;e&#39;: &#39;f&#39;}</code></pre></figure></p>

<h4>Removing Values</h4>

<p>To remove a single value from the hash, use the '~' (tilde) character along with --in-place:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler distro edit --name=foo --ksmeta=&quot;a=b c=d&quot;
$ cobbler distro report --name=foo | grep &quot;Kickstart Meta&quot;
Kickstart Metadata             : {&#39;a&#39;: &#39;b&#39;, &#39;c&#39;: &#39;d&#39;}
$ cobbler distro edit --name=foo --in-place --ksmeta=&#39;~a&#39;
$ cobbler distro report --name=foo | grep &quot;Kickstart Meta&quot;
Kickstart Metadata             : {&#39;c&#39;: &#39;d&#39;}</code></pre></figure></p>

<h4>Suppressing Values</h4>

<p>You can also suppress values from being used, by specifying the '-' character in front of the key name:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler distro edit --name=foo --ksmeta=&quot;a=b c=d&quot;
$ cobbler distro report --name=foo | grep &quot;Kickstart Meta&quot;
Kickstart Metadata             : {&#39;a&#39;: &#39;b&#39;, &#39;c&#39;: &#39;d&#39;}
$ cobbler distro edit --name=foo --in-place --ksmeta=&#39;-a&#39;
$ cobbler distro report --name=foo | grep &quot;Kickstart Meta&quot;
Kickstart Metadata             : {&#39;-a&#39;: &#39;b&#39;, &#39;c&#39;: &#39;d&#39;}</code></pre></figure></p>

<p>In this case, the key=value pair will be ignored when the field is accessed.</p>

<h4>Keys Without Values</h4>

<p>You can always specify keys without a value:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler distro edit --name=foo --ksmeta=&quot;a b c&quot;
$ cobbler distro report --name=foo | grep &quot;Kickstart Meta&quot;
Kickstart Metadata             : {&#39;a&#39;: &#39;~&#39;, &#39;c&#39;: &#39;~&#39;, &#39;b&#39;: &#39;~&#39;}</code></pre></figure></p>

<div class="alert alert-info alert-block"><b>Note:</b> While valid syntax, this could cause problems for some fields where Cobbler expects a value (for example, --template-files).</div>


<h4>Keys With Multiple Values</h4>

<p>It is also possible to specify multiple values for the same key. In this situation, Cobbler will convert the value portion to an array:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler distro edit --name=foo --in-place --ksmeta=&quot;a=b a=c a=d&quot;
$ cobbler distro report --name=foo | grep &quot;Kickstart Meta&quot;
Kickstart Metadata             : {&#39;a&#39;: [&#39;b&#39;, &#39;c&#39;, &#39;d&#39;]}</code></pre></figure></p>

<div class="alert alert-info alert-block"><b>Note:</b> You must specify --in-place for this to work. By default the behavior will result in a single value, with the last specified value being the winner.</div>


<h2>Standard Primitive Sub-commands</h2>

<p>All primitive objects support the following standard sub-commands:</p>

<h3>List</h3>

<p>The list command simply prints out an alphabetically sorted list of all objects.</p>

<p><strong>Example:</strong></p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler distro list
   centos6.3-x86_64
   debian6.0.5-x86_64
   f17-x86_64
   f18-beta6-x86_64
   opensuse12.2-i386
   opensuse12.2-x86_64
   opensuse12.2-xen-i386
   opensuse12.2-xen-x86_64
   sl6.2-i386
   sl6.2-x86_64
   ubuntu-12.10-i386
   ubuntu-12.10-x86_64</code></pre></figure></p>

<p>The list command is actually available as a top-level command as well, in which case it will iterate through every object type and list everything currently stored in your Cobbler database.</p>

<h3>Report</h3>

<p>The report command prints a formatted report of each objects configuration. The optional --name argument can be used to limit the output to a single object, otherwise a report will be printed out for every object (if you have a lot of objects in a given category, this can be somewhat slow).</p>

<p>As with the list command, the report command is also available as a top-level command, in which case it will print a report for every object that is stored in your Cobbler database.</p>

<h3>Remove</h3>

<p>The remove command uses only the --name option.</p>

<div class="alert alert-info alert-block"><b>Note:</b> Removing an object will also remove any child objects (profiles, sub-profiles and/or systems). Prior versions of Cobbler required an additional --recursive option to enable this behavior, but it has become the default in recent versions so use remove with caution.</div>


<p><strong>Example:</strong></p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler [object] remove --name=foo</code></pre></figure></p>

<h3>Copy/Rename</h3>

<p>The copy and rename commands work similarly, with both requiring a --name and --newname options.</p>

<p><strong>Example:</strong></p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler [object] copy --name=foo --newname=bar</p>

<h1>or</h1>

<p>$ cobbler [object] rename --name=foo --newname=bar</code></pre></figure></p>

<h3>Find</h3>

<p>The find command allows you to search for objects based on object attributes.</p>

<p>Please refer to the <a href="/manuals/2.6.0/3/2/7_-_Command_Line_Search.html">Command Line Search</a> section for more details regarding the find sub-command.</p>

<h3>Dumpvars (Debugging)</h3>

<p>The dumpvars command is intended to be used for debugging purposes, and for those writing snippets. In general, it is not required for day-to-day use.</p>
