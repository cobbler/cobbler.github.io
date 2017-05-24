---
layout: index
title: Cobbler - Linux install and update server
cobbler:
  version: 2.8.1
  release: May 24th, 2017
users:
  - img: acision
  - img: alstom
  - img: autotest
  - img: beaker
  - img: beantown
  - img: bytecode
  - img: carol
  - img: dell
  - img: dw
  - img: eucalyptus
  - img: fedora
  - img: flpc
  - img: genome
  - img: kynetx
  - img: linkshare
  - img: mi
  - img: ohio
  - img: ouit
  - img: pnnl
  - img: puzzleitc
  - img: quantcast
  - img: reliam
  - img: spacewalk
  - img: speakeasy
  - img: spi
  - img: spilgames
  - img: stoneit
  - img: sulair
  - img: sunypotsdam
  - img: symbolic
  - img: tomtom
  - img: tripleit
  - img: widexs
---
<script>
$('document').ready(function() {
  $('.carousel').carousel({ interval: 2500 });
});
</script>

<div id="hero" class="hero-unit">
 <div class="container">
  <div class="row-fluid">
   <div class="span9">
    <h1>Welcome to Cobbler!</h1>
    <p class="mainblurb">Cobbler is a Linux installation server that allows for rapid setup of network installation environments. It glues together and automates many associated Linux tasks so you do not have to hop between many various commands and applications when deploying new systems, and, in some cases, changing existing ones. Cobbler can help with provisioning, managing DNS and DHCP, package updates, power management, configuration management orchestration, and much more.</p>
    <p><a href="/manuals/quickstart/" class="btn btn-info btn-large">Get Started Now!</a></p>
   </div>
   <div class="span3">
    <div class="row well heroblurb posts">
     <div class="header">Latest Version:</div>
     <div class="version">{{ page.cobbler.version }}</div>
     <div class="release">released on {{ page.cobbler.release }}</div>
     <div><hr /></div>
     <div class="header latestnews">Latest News:</div>
{% for post in site.posts limit:1 %}
     <div class="post">
      <div class="title"><a href="{{ post.url}}">{{ post.title}}</a></div>
      <div class="author">by {{ post.author }} on {{ post.date | date: "%B %d, %Y" }}</div>
      <!-- <div class="content">{{post.summary}}</div> -->
     </div>
{% endfor %}
     <div class="viewall"><a href="/posts/"><i class="icon-double-angle-right"> view all posts</i></a></div>
    </div>
    <div class="row well heroblurb">
     <div class="header supporters">Thanks to all our supporters!</div>
     <div class="row-fluid supporter">
      <div class="span6"><a href="http://www.eucalyptus.com/"><img src="/images/supporters/eucalyptus.png" /></a></div>
      <div class="span6"><a href="http://www.ansibleworks.com/"><img src="/images/supporters/ansible.png" /></a></div>
     </div>
     <div class="row-fluid supporter">
      <div class="span6"><a href="http://spil.com/cobbler"><img src="/images/supporters/spilgames.png" /></a></div>
      <div class="span6"><a href="http://www.quantcast.com/"><img src="/images/supporters/quantcast.png" /></a></div>
     </div>
     <div class="row-fluid supporter">
      <div class="span6"><a href="http://www.fedoraproject.org/"><img src="/images/supporters/fedora.png" /></a></div>
      <div class="span6"><a href="http://www.puzzle.ch/"><img src="/images/supporters/puzzleitc.png" /></a></div>
     </div>
     <div class="viewall"><a href="/supporters.html"><i class="icon-double-angle-right"> view all supporters</i></a></div>
    </div>
   </div>
  </div>
 </div>
</div>

<div class="row-fluid">
 <div class="span2 offset2">
  <div><img src="/images/gears.jpg" class="img-polaroid" alt="gears" /></div>
 </div>
 <div class="span6">
  <h4>How Does Cobbler Help?</h4>
  <p>Automation is the key to speed, consistency and repeatability. These properties are critical to managing an infrastructure, whether it is comprised of a few servers or a few thousand servers. Cobbler helps by automating the process of provisioning servers from bare metal, or when deploying virtual machines onto various hypervisors.</p>
 </div>
</div>

<div class="row-fluid row-divider">
 <div class="span10 offset1">
  <hr />
 </div>
</div>

<div class="row-fluid">
 <div class="span2 offset2">
  <div><img src="/images/recycle.png" class="img-polaroid" alt="recycle" /></div>
 </div>
 <div class="span6">
  <h4>Reduce, Reuse...</h4>
  <p>Just as configuration management systems rely on templates to simplify updates, so too does Cobbler. Templates are used extensively for management of services like DNS and DHCP, and the response files given to the various distributions (kickstart, preseed, etc.) are all templated to maximize code reuse.</p>
  <p>In addition to templates, Cobbler relies on a system of snippets - small chunks of code (which are really templates themselves) that can be embedded in other templates. This allows admins to write things once, use it wherever they need it via a simple include, all while managing the content in just one place.</p>
 </div>
</div>

<div class="row-fluid row-divider">
 <div class="span10 offset1">
  <hr />
 </div>
</div>

<div class="row-fluid">
 <div class="span2 offset2">
  <div id="myCarousel" class="carousel slide" data-interval="2000">
   <div class="carousel-inner">
{% for user in page.users %}
    <div class="item">
     <div><img class="carousel-img" src="/images/who/{{ user.img }}_logo_sm.png" alt="" /></div>
    </div>
{% endfor %}
   </div>
  </div>
 </div>
 <div class="span6">
  <h4>Who's using Cobbler?</h4>
  <p>These are just a small sample of the hundreds of companies, universities and government orgnaizations that rely on Cobbler every day to build their infrastructure.</p>
  <div class="viewall"><a href="/users.html"><i class="icon-double-angle-right"> view more</i></a></div>
 </div>
</div>

