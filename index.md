---
layout: index
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
<script>
$('document').ready(function() {
  $('.carousel').carousel({ interval: 2500 });
});
</script>

<div id="hero" class="hero-unit">
 <div class="container">
   <h1>Welcome to Cobbler!</h1>
   <p>Cobbler is a Linux installation server that allows for rapid setup of network installation environments. It glues together and automates many associated Linux tasks so you do not have to hop between lots of various commands and applications when rolling out new systems, and, in some cases, changing existing ones. It can help with installation, DNS, DHCP, package updates, power management, configuration management orchestration, and much more.</p>
  <p><a href="/manuals/2.4.0/3_-_Installing_Cobbler.html" class="btn btn-info btn-large">Get Started Now!</a></p>
 </div>
</div>

<div class="row-fluid">
 <div class="span2 offset2">
  <div><img src="/images/gears.jpg" alt="gears" /></div>
 </div>
 <div class="span6">
  <h4>How Does Cobbler Help?</h4>
  <p>Automation is the key to speed, consistency and repeatability. These properties are critical to managing an infrastructure, whether it is comprised of a few servers or a few thousand servers. Cobbler helps by automating the process of provisioning of servers from bare metal or when deploying virtual machines.</p>
 </div>
</div>

<div class="row-fluid">
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
  <p>The companies to the right are just a sample of the hundreds of companies, universities and government orgnaizations that rely on Cobbler every day to build their infrastructure.</p>
  <p><a href="/users.html" class="btn btn-info btn-small">More Info</a></p>
 </div>
</div>

