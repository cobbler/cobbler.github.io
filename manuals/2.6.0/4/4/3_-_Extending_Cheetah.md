
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4_-_Advanced_Topics.html">4</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4/4_-_Extending_Cobbler.html">4</a> <span class="divider">/</span></li><li class="active">Cobbler Manual</li></ul>
   <h1>Cobbler Manual</h1>
<p>Cobbler uses Cheetah for it's templating system, it also wants to support other
choices and may in the future support others.</p>

<p>It is possible to add new functions to the templating engine, much
like snippets, that provide the ability to do macro-based things
in the template. If you are new to Cheetah, see the documentation at
<a href="http://www.cheetahtemplate.org/learn.html">http://www.cheetahtemplate.org/learn.html</a>
and pay special attention to the #def directive.</p>

<p>To create new functions, add your Cheetah code to
<code>/etc/cobbler/cheetah_macros</code>. This file will be sourced in all
Cheetah templates automatically, making it possible to write custom
functions and use them from this file.</p>

<p>You will need to restart cobblerd after changing the macros file.</p>
