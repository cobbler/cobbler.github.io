---
layout: default
title: Cobbler - Linux install and update server

users:
  - img: acision
    url: http://www.acision.com
  - img: alstom
    url: http://www.alstom.com
  - img: beaker
    url: 
  - img: beantown
    url: 
  - img: carol
    url: 
  - img: dell
    url: 
  - img: dw
    url: 
  - img: flpc
    url: 
  - img: genome
    url: 
  - img: kynetx
    url: 
  - img: linkshare
    url: 
  - img: luminoso
    url: 
  - img: mi
    url: 
  - img: ohio
    url: 
  - img: ouit
    url: 
  - img: pnnl
    url: 
  - img: puzzleitc
    url: 
  - img: reliam
    url: 
  - img: spacewalk
    url: 
  - img: speakeasy
    url: 
  - img: spi
    url: 
  - img: stoneit
    url: 
  - img: sulair
    url: 
  - img: sunypotsdam
    url: 
  - img: symbolic
    url: 
  - img: tomtom
    url: 
  - img: tripleit
    url: 
  - img: widexs
    url: 
---

<hr>
<script>
$('document').ready(function() {
  $('.carousel').carousel({ interval: 5000 });
});
</script>
<div id="myCarousel" class="carousel slide" data-interval="3000">
  <div class="carousel-inner">
    <div class="item active">
{% for user in page.users %}
      <div class="span2"><a href="{{ user.url }}"><img class="carousel-img" src="/images/who/{{ user.img }}_logo_sm.png" alt="" /></a></div>
    {% capture current %}{% cycle 'group 1': '','','','','','goose' %}{% endcapture %}
    {% if current != '' %}
    </div>
    <div class="item">
    {% endif %}
{% endfor %}
    </div>
  </div>
</div>
<hr>

# Welcome to Cobbler
Cobbler is a Linux installation server that allows for rapid setup of network installation environments. It glues together and automates many associated Linux tasks so you do not have to hop between lots of various commands and applications when rolling out new systems, and, in some cases, changing existing ones.  It can help with installation, DNS, DHCP, package updates, power management, configuration management orchestration, and much more.

{% for post in site.posts limit:5 %}
## [{{ post.title}}]({{post.url}})
<p class="postauthor"><i>Posted by {{ post.author }} on {{ post.date | date: "%A, %B %d, %Y" }}</i></p>
{{post.content}}
{% endfor %}
