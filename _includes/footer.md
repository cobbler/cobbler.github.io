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
          <li><a href="/about.html">About Cobbler</a></li>
         </ul>
        </div>
        <div class="span2 sitemap">
         <ul class="nav nav-list">
          <li class="nav-header">Manuals</li>
          <li><a href="/manuals/2.4.0/">2.4.0</a></li>
          <li><a href="/manuals/2.2.3/">2.2.3</a></li>
         </ul>
        </div>
        <div class="span3 sitemap">
         <ul class="nav nav-list">
          <li class="nav-header">Community</li>
          <li><a href="/community.html">How to Get Help</a></li>
          <li><a href="/supporters.html">Supporters</a></li>
         </ul>
        </div>
        <div class="span4 sitemap">
         <ul class="nav nav-list">
          <li class="nav-header">Github</li>
          <li><a href="https://github.com/cobbler/cobbler">Main Code Repository</a></li>
          <li><a href="https://github.com/cobbler/cobbler/issues">Issue Tracker</a></li>
          <li><a href="https://github.com/cobbler/cobbler/wiki">Wiki (deprecated)</a></li>
         </ul>
        </div>
       </div>
      </div>
      <div class="span3 posts">
        <p class="column_header">Recent Posts:</p>
{% for post in site.posts limit:4 %}
        <div class="post">
          <p class="title"><a href="{{ post.url}}">{{ post.title}}</a></p>
          <p class="author">Posted by {{ post.author }} on {{ post.date | date: "%A, %B %d, %Y" }}</p>
          <p class="content">{{post.summary}}</p>
        </div>
{% endfor %}
      </div>
      <div class="span3 credits">
        <div class="social">
          <a href="https://twitter.com/cobblerista" class="twitter-follow-button" data-show-count="false" data-size="large" data-dnt="true" data-width="100%">Follow @cobblerista</a>
          <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
        </div>
        <div class="attributions">
          <p class="column_header">Attributions:</p>
          <div class="attribution">"Lens Flare", by <a href="http://creativity103.com/"><img src="http://creativity103.com/bmers/creativitybloggry.gif" /></a></div>
          <div class="attribution">"Gears", by <a href="http://www.flickr.com/photos/17258892@N05/">Ralph Bijker</a></div>
        </div>
        <div class="copyright">
          All other content, &copy; <span id="copyyear"></span><br/>by James Cammarata
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
