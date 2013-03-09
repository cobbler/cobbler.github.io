---
layout: default
title: Who's Using Cobbler
users:
  - img: acision
    url: http://www.acision.com
  - img: alstom
    url: http://www.alstom.com/
  - img: beantown
    url: http://beantownhost.com
  - img: carol
    url: http://www.carol.com/
  - img: dell
    url: http://www.dell.com
  - img: eucalyptus
    url: http://www.eucalyptus.com/
  - img: flpc
    url: http://www.uclug.org/flpc
  - img: kynetx
    url: http://www.kynetx.com
  - img: linkshare
    url: http://linkshare.com
  - img: mi
    url: http://www.mcclatchyinteractive.com/
  - img: ohio
    url: http://www.ohio.edu
  - img: ouit
    url: http://www.ou.edu/ouit
  - img: pnnl
    url: http://pnl.gov
  - img: puzzleitc
    url: http://puzzle.ch
  - img: speakeasy
    url: http://speakeasy.net
  - img: spi
    url: http://imageworks.com/
  - img: stoneit
    url: http://www.stone-it.com
  - img: sulair
    url: http://library.stanford.edu
  - img: sunypotsdam
    url: http://www.potsdam.edu
  - img: tomtom
    url: http://www.tomtom.com
  - img: tripleit
    url: http://www.triple-it.nl/
  - img: widexs
    url: http://www.widexs.nl
projects:
  - img: autotest
    url: http://autotest.github.com/
  - img: beaker
    url: http://beaker-project.org/
  - img: bytecode
    url: http://www.byte-code.com
  - img: dw
    url: http://dashwire.com
  - img: genome
    url: http://genome.et.redhat.com
  - img: reliam
    url: http://reliam.com
  - img: spacewalk
    url: http://fedorahosted.org/spacewalk
  - img: symbolic
    url: http://www.opensymbolic.org
---

# Who's Using Cobbler

Cobbler is currently in use at a wide-variety of organizations such as hosting companies, financial institutions, datacenters, compute grids/clusters, universities, K-12 schools, consulting groups, ISVs, and world government agencies and departments.  Many home users and small to mid-size companies can and do use it as well.

The following is an opt-in list of some Cobbler users. To either add or remove your company/organization from this list, please [open an issue here](https://github.com/cobbler/cobbler.github.com/issues).

## Companies Using Cobbler

<div class="container logolist">
 <div class="row-fluid">
{% for user in page.users %}
  <div class="span3 userlogo"><a href="{{ user.url }}"><img src="/images/who/{{ user.img }}_logo_sm.png" alt="" /></a></div>
 {% capture current %}{% cycle 'users': '','','','goose' %}{% endcapture %}
 {% if current != '' %}
 </div>
 <div class="row-fluid">
 {% endif %}
{% endfor %}
 </div>
</div>

## Applications Using Cobbler (As a Service)

<div class="container logolist">
 <div class="row-fluid">
{% for project in page.projects %}
  <div class="span3 userlogo"><a href="{{ project.url }}"><img src="/images/who/{{ project.img }}_logo_sm.png" alt="" /></a></div>
 {% capture current %}{% cycle 'projects': '','','','goose' %}{% endcapture %}
 {% if current != '' %}
 </div>
 <div class="row-fluid">
 {% endif %}
{% endfor %}
 </div>
</div>

