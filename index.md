---
layout: default
title: Cobbler - Linux install and update server

users:
  - img: acision
  - img: alstom
  - img: autotest
  - img: beaker
  - img: beantown
  - img: carol
  - img: dell
  - img: dw
  - img: flpc
  - img: genome
  - img: kynetx
  - img: linkshare
  - img: luminoso
  - img: mi
  - img: ohio
  - img: ouit
  - img: pnnl
  - img: puzzleitc
  - img: reliam
  - img: spacewalk
  - img: speakeasy
  - img: spi
  - img: stoneit
  - img: sulair
  - img: sunypotsdam
  - img: symbolic
  - img: tomtom
  - img: tripleit
  - img: widexs
---

# Welcome to Cobbler
Cobbler is a Linux installation server that allows for rapid setup of network installation environments. It glues together and automates many associated Linux tasks so you do not have to hop between lots of various commands and applications when rolling out new systems, and, in some cases, changing existing ones.  It can help with installation, DNS, DHCP, package updates, power management, configuration management orchestration, and much more.

<div class="span12">
  <div class="span6">
  </div>
  <div class="span6">
{% for post in site.posts limit:5 %}
    <div>
      <b><a href="{{post.url}}">{{ post.title}}</a></b>
      <p class="postauthor"><i>Posted by {{ post.author }} on {{ post.date | date: "%A, %B %d, %Y" }}</i></p>
    </div>
{% endfor %}
  </div>
</div>

<script>
$('document').ready(function() {
  $('.carousel').carousel({ interval: 5000 });
});
</script>

<div class="span12">
  <hr>
  <div id="myCarousel" class="carousel slide" data-interval="3000">
    <div class="carousel-inner">
      <div class="item active">
{% for user in page.users %}
        <div class="span2"><img class="carousel-img" src="/images/who/{{ user.img }}_logo_sm.png" alt="" /></div>
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
</div>

