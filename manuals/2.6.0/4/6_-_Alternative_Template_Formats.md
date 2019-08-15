
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4_-_Advanced_Topics.html">4</a> <span class="divider">/</span></li><li class="active">Alternative Template Formats</li></ul>
   <h1>Alternative Template Formats</h1>
<p>The default templating engine currently is Cheetah, as of cobbler 2.4.0 support for the Jinja2 templating engine has been added.</p>

<p>The default template type to use in the absence of any other detected. If you do not specify the template with '#template=<template_type>' on the first line of your templates/snippets, cobbler will assume try to use the template engine as specified in the settings file to parse the templates.</p>

<p>From /etc/cobbler/settings:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash"># Current valid values are: cheetah, jinja2
default_template_type: &quot;cheetah&quot;</code></pre></figure></p>
