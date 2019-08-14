<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en-us">
<head>
   <meta http-equiv="content-type" content="text/html; charset=utf-8" />
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <meta name="author" content="Cobbler development team" />

   <title>Locking Down Cobbler</title>

   <!-- CSS -->
   <link rel="stylesheet" type="text/css" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" />
   <link rel="stylesheet" type="text/css" href="/lib/bootstrap/css/bootstrap.min.css" />
   <link rel="stylesheet" type="text/css" href="/lib/bootstrap/css/bootstrap-responsive.min.css" />
   <link rel="stylesheet" type="text/css" href="/lib/font/font-awesome.css" />
   <link rel="stylesheet" type="text/css" href="/lib/font/font-awesome-ext.css" />
   <link rel="stylesheet" type="text/css" href="/css/syntax.css" />
   <link rel="stylesheet" type="text/css" href="/css/style.css" />
   <link rel="stylesheet" type="text/css" href="/css/search.css" />

   <!-- Fonts -->
   <link rel='stylesheet' type='text/css' href='http://fonts.googleapis.com/css?family=Habibi|Roboto+Condensed' />

   <!--[if lt IE 9]>
     <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
   <![endif]-->

   <!-- Icon -->
   <link rel="icon" type="image/png" href="/images/favicon.png" />

   <!-- JQuery/Bootstrap/custom scripts -->
   <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
   <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js"></script>
   <script type="text/javascript" src="/lib/bootstrap/js/bootstrap.min.js"></script>
   <script type="text/javascript" src="/js/jquery.ba-hashchange.min.js"></script>
   <script type="text/javascript" src="/js/jquery.swiftype.search.js"></script>
</head>
<body class="pull_up">

<!-- ClickTale Top part -->
<script type="text/javascript">
var WRInitTime=(new Date()).getTime();
</script>
<!-- ClickTale end of Top part -->

<div class="navbar transparent navbar-inverse navbar-static-top">
 <div class="navbar-inner">
  <div class="container">
   <a class="brand" href="/"><img class="logo" src="/images/logo-brand.png" /></a>
   <div class="nav-collapse collapse">
    <ul class="nav pull-right">
     <li><a href="/about.html" title="About"><i class="icon-cloud icon-med"></i> About </a></li>
     <li class="dropdown">
       <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-question-sign icon-med"></i> Downloads <b class="caret"></b></a>
       <ul class="dropdown-menu">
         <li><a href="/downloads/2.8.x.html" title="Cobbler 2.8.x">2.8.x</a></li>
         <li><a href="/downloads/2.6.x.html" title="Cobbler 2.6.x">2.6.x</a></li>
         <li><a href="/downloads/2.4.x.html" title="Cobbler 2.4.x">2.4.x</a></li>
       </ul>
     </li>
     <li><a href="/blog/" title="Blog Posts"><i class="icon-bookmark icon-med"></i> Blog Posts</a></li>
     <li class="dropdown">
       <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-question-sign icon-med"></i> Manuals <b class="caret"></b></a>
       <ul class="dropdown-menu">
         <li><a href="/manuals/quickstart/" title="Quickstart Guide">Quickstart Guide</a></li>
         <li><a href="/manuals/2.8.0/" title="Version 2.8.x">User Manual 2.8.x</a></li>
         <li><a href="/manuals/2.6.0/" title="Version 2.6.x">User Manual 2.6.x</a></li>
         <li><a href="/manuals/2.4.0/" title="Version 2.4.x">User Manual 2.4.x</a></li>
         <li><a href="/manuals/developer/" title="Developer Guide">Developer Guide</a></li>
       </ul>
     </li>
     <li class="dropdown">
       <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-group icon-med"></i> Community <b class="caret"></b></a>
       <ul class="dropdown-menu">
         <li><a href="/community.html" title="How to Get Help">How to Get Help</a></li>
         <li><a href="/supporters.html" title="Supporters of Cobbler">Supporters</a></li>
         <li><a href="/users.html" title="Cobbler Users">Who's Using Cobbler</a></li>
       </ul>
     </li>
     <li class="dropdown">
       <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-github icon-med"></i> Github <b class="caret"></b></a>
       <ul class="dropdown-menu">
        <li><a href="https://github.com/cobbler/cobbler" title="Main Repository" target="_blank">Main Repo</a></li>
        <li><a href="https://github.com/cobbler/cobbler/issues" title="Issues" target="_blank">Issue Tracker</a></li>
        <li><a href="https://github.com/cobbler/cobbler/wiki" title="Github Wiki" target="_blank">Wiki</a></li>
       </ul>
     </li>
     <li>
      <form class="pull-right">
       <input type="text" id="st-search-input" class="st-search-input" />
      </form>
     </li>
    </ul>
    <!-- <div id="st-results-container"></div> -->
    <script type="text/javascript">
      var Swiftype = window.Swiftype || {};
      (function() {
        Swiftype.key = 'ybEhsDqz2mEFrMtBHiwB';
        Swiftype.inputElement = '#st-search-input';
        Swiftype.resultContainingElement = '#st-results-container';
        Swiftype.attachElement = '#st-search-input';
        Swiftype.renderStyle = "new_page";
        Swiftype.resultPageURL = '/search.html';
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.async = true;
        script.src = "//swiftype.com/embed.js";
        var entry = document.getElementsByTagName('script')[0];
        entry.parentNode.insertBefore(script, entry);
      }());
    </script>
   </div>
   <!--
   <form class="navbar-search pull-right" onsubmit="return false;">
    <input id="searchbox" type="text" class="search-query" placeholder="Search Manuals" />
   </form>
   -->
  </div>
 </div>
</div>


<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/5_-_Web_Interface.html">5</a> <span class="divider">/</span></li><li class="active">Locking Down Cobbler</li></ul>
   <h1>Locking Down Cobbler</h1>
<p>If you want to enable the
<a href="Cobbler%20web%20interface">Cobbler web interface</a> for a lot
of users, and don't trust all of them to know what they are doing
all of the time, here are some tips on some good configuration
practices to allow for configuring a server that is hard for
someone to mess with in ways they shouldn't be messing with it --
as defined by you and your site specific policy.</p>

<h2>/etc/cobbler/modules.conf</h2>

<p>For
<a href="Web%20Authentication">Web Authentication</a>,
choose authn_kerberos or authn_ldap if you don't have Kerberos.
See <a href="Kerberos">Kerberos</a> and
<a href="Ldap">LDAP</a> for details on how
to set those up. Failing that, using the authn_digest is perfectly
fine, but don't share passwords among the users. Logging goes to
<code>/var/log/cobbler/\*.log</code> and can be used to see what user does
what.</p>

<p>For <a href="Security%20Overview">Customizable Security</a>,
choose authz_ownership, as this will allow users to only edit
things that they create unless you declare certain users to be
admins. You should then define groups for users in
<code>/etc/cobbler/users.conf</code> following the format of that file, then
assign objects in cobbler (like distros, etc) ownership as
described in
<a href="/cobbler/wiki/AuthorizationWithOwnership">AuthorizationWithOwnership</a>.</p>

<h2>Firewall</h2>

<p>For koan to work you must unblock 25150 (XMLRPC/tcp-ip) as well as
HTTP 80, HTTPS 443 and TFTP 69 (tcp/udp) if you want PXE.</p>

<p>If you want to access read-write XMLRPC from outside the cobbler
server, you'll need to unblock 25151.</p>

<p>Also, if applicable, unblock DHCP!</p>

<p>While it may be tempting to disable cobblerd, don't... cobbler uses
cobblerd to generate dynamic content such as
<a href="Kickstart%20Templates">Kickstart Templates</a> and this
will mean nothing will work. Koan additionally communicates with
cobblerd.</p>

<h2>SELinux</h2>

<p>Cobbler works with SELinux -- though you should be using EL 5 or
later. EL 4 is not supported since it does not have
public_content_t, meaning files can't be served from Apache and
TFTP at the same time.</p>

<p>You should install the semanage rules that "cobbler check" tells
you about to ensure everything works according to plan.</p>

<p>Also note, you may run into some problems if you need to relocate
your <code>/var/www elsewhere</code>, which most users should not need to do.</p>

<h2>Default Passwords</h2>

<p>Run "cobbler check" and it will warn you if any of the sample
kickstarts still have "cobbler" as the password. If you are using
those templates, that's a problem, if not, don't worry about it,
but you may want to comment out the password line to prevent them
from being used.</p>

<h2>Test Your Configuration</h2>

<p>Log in as various users (create some in different groups if need
be) to make sure your authorization, authentication, and/or ACLs
are correct as you expect them. Then also make sure you can deploy
some physical and virtual systems outside the network to ensure
your firewall configurations do not cut off anything important.</p>

<h2>Command Line ACLs</h2>

<p>All of the above is about network security, if you want to run the
cobbler CLI as non root, you can run "cobbler aclsetup" to grant
access to non-root users, such as your friendly trusted
neighborhood administrators. Be aware this grants them file access
on all of cobbler's configuration. This all uses setfacl, don't
chmod yourself if you can help it as the RPM takes good steps to
get all of this right. Same for running setfacl yourself as there
are lots of places it must be applied.</p>

<h2>A Note About File Readablity and "Security"</h2>

<p>By nature of provisioning, TFTP and HTTP and so forth are typically
wide open protocols by design. This is actually a good thing due to
the Catch-22 that if it was hard to install, installing would be
hard. Ease of installation requires openness, so these steps above
are about keeping people from changing your provisioning
configurations to ways that they should not have access to change
them -- they are not about denying access to data in the
provisioning server, such as the contents of kickstarts. If you
need to be transferring sensitive files, a long "HERE" document in
kickstart %post is not the place to do it. scp those later or use a
config management system to move the files.</p>

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
<div class="toc"><ul class="dirtree"><li><a href="/manuals/2.6.0/5/1_-_Security_Overview.html">1 - Security Overview</a></li><li><a href="/manuals/2.6.0/5/2_-_Web_Authentication.html">2 - Web Authentication</a></li><ul class="dirtree"><li><a href="/manuals/2.6.0/5/2/1_-_PAM.html">2.1 - PAM</a></li><li><a href="/manuals/2.6.0/5/2/2_-_LDAP.html">2.2 - LDAP</a></li><li><a href="/manuals/2.6.0/5/2/3_-_Kerberos.html">2.3 - Kerberos</a></li><li><a href="/manuals/2.6.0/5/2/4_-_Spacewalk.html">2.4 - Spacewalk</a></li><li><a href="/manuals/2.6.0/5/2/5_-_Passthru.html">2.5 - Passthru</a></li><li><a href="/manuals/2.6.0/5/2/6_-_Digest.html">2.6 - Digest</a></li></ul><li><a href="/manuals/2.6.0/5/3_-_Web_Authorization.html">3 - Web Authorization</a></li><li><a href="/manuals/2.6.0/5/4_-_Locking_Down_Cobbler.html">4 - Locking Down Cobbler</a></li></ul></div>
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

