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
          <li><a href="/posts/">Blog Posts</a></li>
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
{% for post in site.posts limit:4 %}
        <div class="post">
          <p class="title"><a href="{{ post.url}}">{{ post.title}}</a></p>
          <p class="author">Posted by {{ post.author }} on {{ post.date | date: "%A, %B %d, %Y" }}</p>
        </div>
{% endfor %}
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
