---
layout: manpage
title: Frequently Asked Trouble Shooting Questions
meta: 2.6.0
---

<p>This section covers some questions that frequently come up in IRC,
some of which are problems, and some of which are things about
Cobbler that are not really problems, but are things folks just ask
questions about frequently...</p>

<p>See also
<a href="Virtualization%20Troubleshooting">Virtualization Troubleshooting</a>
for virtualization specific questions.</p>

<h1>General</h1>

<h2>Most Common Things To Check</h2>

<p>Have you run Cobbler check? What did it say? Is Cobbler and koan at
the most recent released stable version? Is cobblerd running? Have
you tried restarting it if this is a recent upgrade or config
change? If something isn't showing up, have you restarted cobblerd
and run "cobbler sync" after making changes to the config file? If
you can't connect or retrieve certain files, is Apache running, or
have you restarted it after a new install? If there's a koan
connectivity problem, are there any firewalls blocking port 25150?</p>

<h2>I am having a problem with importing repos</h2>

<p>Trick question! one does not run "cobbler import" on repos :)
Install trees contain more data than repositories. Install trees
are for OS installation and are added using "cobbler import" or
"cobbler distro add" if you want do something more low level.
Repositories are for things like updates and additional packages.
Use "cobbler repo add" to add these sources. If you accidentally
import a repo URL (for instance using rsync), clean up
/var/www/cobbler/ks_mirror/name_you_used to take care of it.
Cobbler can't detect what you are importing in advance before you
copy it. Thankfully "man cobbler" gives plenty of good examples for
each command, "cobbler import" and "cobbler repo add" and gives
example URLs and syntaxes for both.</p>

<p>See also <a href="Using%20Cobbler%20Import">Using Cobbler Import</a> and
<a href="Manage%20Yum%20Repos">Manage Yum Repos</a> for further
information.</p>

<h2>Why do the kickstart files in /etc/cobbler look strange?</h2>

<p>These are not actually kickstart files, they are kickstart file
templates. See
<a href="Kickstart%20Templating">Kickstart Templating</a> for more
information.</p>

<h2>How can I validate that my kickstarts are right before installing?</h2>

<p>Try "cobbler validateks"</p>

<h2>Can I feed normal kickstart files to --kickstart ?</h2>

<p>You can, but you need to escape any dollar signs ($) with (\$) so
the Cobbler templating engine doesn't eat them. This is not too
hard, use "cobbler profile getks" and "cobbler system getks" to
make sure everything renders correctly. Also #raw ... #endraw in
Cheetah can be useful. More is documented on the
<a href="Kickstart%20Templating">Kickstart Templating</a> page.</p>

<h2>My kickstart file has problems</h2>

<p>If it's not related to Cobbler's
<a href="Kickstart%20Templating">Kickstart Templating</a> engine,
and it's more of "how do I do this in pre/post", kickstart-list is
excellent.</p>

<p><a href="http://www.redhat.com/mailman/listinfo/kickstart-list">http://www.redhat.com/mailman/listinfo/kickstart-list</a></p>

<p>Also be sure to read the archives, I have created a Google custom
search engine for this
<a href="http://www.google.com/coop/cse?cx=016811804524159694721:1h7btspnxtu">here</a>.</p>

<p>Otherwise, you are likely seeing a Cheetah syntax error. Learn more
about Cheetah syntax at
<a href="http://cheetahtemplate.org/learn">http://cheetahtemplate.org/learn</a>
for further information.</p>

<h2>I'm running into the 255 character kernel options line limit</h2>

<p>This can be a problem. Adding a CNAME for your cobbler server that
is accessible everywhere, such as "cobbler", or even "boot" can
save a lot of characters over hostname.xyz.acme-corp.internal.org.
It will show up twice in the kernel options line, once for the
kickstart URL, and once for the kickstart URL. Save characters by
not using FQDNs when possible. The IP may also be shorter in some
cases. Cobbler should try to remove optional kernel args in the
event of overflow (like syslog) but you still need to be careful.</p>

<p>(Newer kernels are supposed to not have this limit)</p>

<h2>I'm getting PXE timeouts and my cobbler server is also a virtualized host and I'm using dnsmasq for DHCP</h2>

<p>Libvirtd starts an instance of dnsmasq unrelated to the DHCP needed
for cobbler to PXE -- it's just there for local networking but can
cause conflicts. If you want PXE to work, do not run libvirtd on
the cobbler server, or use ISC dhcpd instead. You can of course run
libvirtd on any other guests in your management network, and if you
don't need PXE support, running libvirtd on the cobbler server is
also fine.</p>

<p>Alternatively you can configure your DHCP server not to listen on
all interfaces: dnsmasq run by libvirtd is configured to listen on
internal virbr0/192.168.122.1 only. For ISC dhcpd you can set in
/etc/sysconfig/dhcpd:</p>

<pre><code>DHCPDARGS=eth0
</code></pre>

<p>For dnsmasq you can set in <code>/etc/dnsmasq.conf</code>:</p>

<pre><code>interface=eth0
except-interface=lo
bind-interfaces
</code></pre>

<h2>I'm having DHCP timeouts / DHCP is slow / etc</h2>

<p>See the Anaconda network troubleshooting page:
<a href="http://fedoraproject.org/wiki/Anaconda/NetworkIssues">http://fedoraproject.org/wiki/Anaconda/NetworkIssues</a></p>

<p>This URL has "Fedora" in it, but applies equally to Red Hat and
derivative distributions.</p>

<h2>Cobblerd won't start</h2>

<p>cobblerd won't start and say:</p>

<blockquote><p>Starting cobbler daemon: Traceback (most recent call last):
  File "/usr/bin/cobblerd", line 76, in main
    api = cobbler_api.BootAPI(is_cobblerd=True)
  File "/usr/lib/python2.6/site-packages/cobbler/api.py", line 127, in <strong>init</strong>
    module_loader.load_modules()
  File "/usr/lib/python2.6/site-packages/cobbler/module_loader.py", line 62, in load_modules
    blip =  <strong>import</strong>("modules.%s" % ( modname), globals(), locals(), [modname])
  File "/usr/lib/python2.6/site-packages/cobbler/modules/authn_pam.py", line 53, in <module>
    from ctypes import CDLL, POINTER, Structure, CFUNCTYPE, cast, pointer, sizeof
  File "/usr/lib64/python2.6/ctypes/<strong>init</strong>.py", line 546, in <module>
    CFUNCTYPE(c_int)(lambda: None)
MemoryError
                                                           [  OK  ]</p></blockquote>

<p>Check your SELinux. Immediate fix is to disable selinux:</p>

<pre><code>setenforce 0
</code></pre>

     <hr>
     <div id="disqus_thread"></div>
     <script type="text/javascript">
        /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
        var disqus_shortname = 'cobbler'; // required: replace example with your forum shortname
        var disqus_identifier = '';

        /* * * DON'T EDIT BELOW THIS LINE * * */
        (function() {
            var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
            dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
        })();
     </script>
     <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
     <a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>


  </div>
  <div class="span4">
<div class="toc"><ul class="dirtree"><li><a href="/manuals/2.6.0/7/1_-_Debugging-tips.html">1 - Debugging-tips</a></li><li><a href="/manuals/2.6.0/7/2_-_Hints-redhat.html">2 - Hints-redhat</a></li><li><a href="/manuals/2.6.0/7/3_-_Virtualization-troubleshooting.html">3 - Virtualization-troubleshooting</a></li></ul></div>
  </div>
 </div>
</div>
<!-- end content -->

<footer>
  <div class="container">
    <div class="row-fluid sections">
      <div class="span6 footmenu">
       <div class="row-fluid">
        <div class="span3 sitemap">
         <ul class="nav nav-list">
          <li class="nav-header">Pages</li>
          <li><a href="/">Home</a></li>
          <li><a href="/blog/">Blog Posts</a></li>
          <li><a href="/about.html">About Cobbler</a></li>
         </ul>
        </div>
        <div class="span2 sitemap">
         <ul class="nav nav-list">
          <li class="nav-header">Manuals</li>
          <li><a href="/manuals/quickstart/">Quickstart</a></li>
          <li><a href="/manuals/2.8.0/">2.8.x</a></li>
          <li><a href="/manuals/2.6.0/">2.6.x</a></li>
          <li><a href="/manuals/developer/">Developer</a></li>
         </ul>
        </div>
        <div class="span3 sitemap">
         <ul class="nav nav-list">
          <li class="nav-header">Community</li>
          <li><a href="/community.html">How to Get Help</a></li>
          <li><a href="/supporters.html">Supporters</a></li>
          <li><a href="/users.html">Who's Using Cobbler</a></li>
         </ul>
        </div>
        <div class="span4 sitemap">
         <ul class="nav nav-list">
          <li class="nav-header">Github</li>
          <li><a href="https://github.com/cobbler/cobbler">Code Repository</a></li>
          <li><a href="https://github.com/cobbler/cobbler/issues">Issue Tracker</a></li>
          <li><a href="https://github.com/cobbler/cobbler/wiki">Wiki</a></li>
         </ul>
        </div>
       </div>
    <div class="row-fluid">
    </div>
    <div class="row-fluid">
     <p class="ending">Best viewed in anything but Internet Explorer&#0153; Seriously, please consider switching.</p>
     <p class="browsers">
      <a href="https://www.mozilla.org/en-US/firefox/new/"><i class="icon-firefox icon-2x"></i></a>
      <a href="https://www.google.com/intl/en/chrome/browser/"><i class="icon-chrome icon-2x"></i></a>
      <a href="http://www.opera.com/"><i class="icon-opera icon-2x"></i></a>
      <a href="http://www.apple.com/safari/"><i class="icon-safari icon-2x"></i></a>
     </p>
    </div>
      </div>
      <div class="span3 posts">
        <p class="column_header">Recent Posts:</p>

        <div class="post">
          <p class="title"><a href="/blog/2018/11/23/cobbler_2.8.4_released.md">Cobbler 2.8.4 Released</a></p>
          <p class="author">Posted by Jörgen on Friday, November 23, 2018</p>
        </div>

        <div class="post">
          <p class="title"><a href="/blog/2018/05/04/cobbler_2.8.3_released.md">Cobbler 2.8.3 Released</a></p>
          <p class="author">Posted by Jörgen on Friday, May 04, 2018</p>
        </div>

        <div class="post">
          <p class="title"><a href="/blog/2017/09/16/cobbler_2.8.2_released.html">Cobbler 2.8.2 Released</a></p>
          <p class="author">Posted by Jörgen on Saturday, September 16, 2017</p>
        </div>

        <div class="post">
          <p class="title"><a href="/blog/2017/05/24/cobbler_2.8.1_released.html">Cobbler 2.8.1 Released</a></p>
          <p class="author">Posted by Jörgen on Wednesday, May 24, 2017</p>
        </div>

      </div>
      <div class="span3 credits">
        <div class="social">
          <a href="https://twitter.com/cobblerproject" class="twitter-follow-button" data-show-count="false" data-size="large" data-dnt="true" data-width="100%">Follow @cobblerproject</a>
          <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
        </div>
        <div class="attributions">
          <p class="column_header">Attributions:</p>
          <div class="attribution">"Lens Flare", by <a href="http://creativity103.com/"><img src="/images/creativity103.gif" /></a></div>
          <div class="attribution">"Gears", by <a href="http://www.flickr.com/photos/17258892@N05/">Ralph Bijker</a></div>
        </div>
        <div class="copyright">
          <p>All other content, &copy; <span id="copyyear"></span><br/>by James Cammarata</p>
          <script>$("#copyyear").text((new Date).getFullYear());</script>
        </div>
      </div>            
    </div>
  </div>
</footer>

<!-- Google Analytics -->
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-27319020-1']);
  _gaq.push(['_trackPageview']);
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>
<!-- Google Analytics end -->

</body>
</html>

