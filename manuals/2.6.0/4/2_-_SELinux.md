
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4_-_Advanced_Topics.html">4</a> <span class="divider">/</span></li><li class="active">SELinux With Cobbler</li></ul>
   <h1>SELinux With Cobbler</h1>
<p>SELinux policies are typically provided by the upstream distribution (Fedora, Ubuntu, etc.). As new features are added to cobbler (and we do add new features frequently), those policies may become out-of-date leading to AVC denials and other problems. If you wish to run SELinux on your cobbler system, we expect you to know how to write policy and resolve AVCs.</p>

<p>Below are some of the more common issues you may run into with this release.</p>

<h2>ProtocolError: &lt;ProtocolError for x.x.x.x:80/cobbler_api: 503 Service Temporarily Unavailable&gt;</h2>

<p>If you see this when you run "cobbler check" or any other cobbler command, it means SELinux is blocking httpd from talking with cobblerd. The command to fix this is:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ sudo setsebool -P httpd_can_network_connect true</code></pre></figure></p>

<h2>Fedora 16 / RHEL6 / CentOS6 - Python MemoryError</h2>

<p>When starting cobblerd for the first time (or after upgrading to 2.2.x), you may see a stack trace like the following:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">Starting cobbler daemon: Traceback (most recent call last):
File &quot;/usr/bin/cobblerd&quot;, line 76, in main
api = cobbler_api.BootAPI(is_cobblerd=True)
File &quot;/usr/lib/python2.6/site-packages/cobbler/api.py&quot;, line 127, in init
module_loader.load_modules()
File &quot;/usr/lib/python2.6/site-packages/cobbler/module_loader.py&quot;, line 62, in load_modules
blip = import(&quot;modules.%s&quot; % ( modname), globals(), locals(), [modname])
File &quot;/usr/lib/python2.6/site-packages/cobbler/modules/authn_pam.py&quot;, line 53, in
from ctypes import CDLL, POINTER, Structure, CFUNCTYPE, cast, pointer, sizeof
File &quot;/usr/lib64/python2.6/ctypes/init.py&quot;, line 546, in
CFUNCTYPE(c_int)(lambda: None)
MemoryError</code></pre></figure></p>

<p>This error is caused by SELinux blocking python ctypes. To resolve this, you can use audit2allow to enable the execution of temp files or you can remove the authn_pam.py module from the site-packages/cobbler/modules/ directory (as long as you're not using PAM authentication for the Web UI).</p>
