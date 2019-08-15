
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/2_-_Installing_Cobbler.html">2</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/2/4_-_Configuration_Files.html">4</a> <span class="divider">/</span></li><li class="active">Settings File</li></ul>
   <h1>Settings File</h1>
<p>The main settings file for cobbler is <code>/etc/cobbler/settings</code>. Cobbler also supports <a href="/manuals/2.6.0/3/3/1_-_Dynamic_Settings.html">Dynamic Settings</a>, so it is no longer required to manually edit this file if this feature is enabled. This file is YAML-formatted, and with dynamic settings enabled <a href="http://augeas.net/" target="_blank">augeas</a> is used to modify its contents.</p>

<p>Whether dynamic settings are enabled or not, if you directly edit this file you must restart cobblerd. When modified with the dynamic settings CLI command or the web GUI, changes take affect immediately and do not require a restart.</p>
