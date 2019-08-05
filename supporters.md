---
layout: default
title: Cobbler Supporters
breadcrumb: Supporters
contributors:
  - name: Platinum
    items:
    - name: Eucalyptus
      url: http://www.eucalyptus.com/
      logo: eucalyptus_big.png
    - name: The Fedora Project
      url: http://fedoraproject.org/
      logo: fedora_big.png
    - name: Spil Games 
      url: http://spil.com/cobbler
    - name: Puzzle ITC
      url: http://cobbler.github.com/images/supporters/puzzleitc.png
    - name: Quantcast
      url: http://www.quantcast.com/
  - name: Gold
    items:
    - name: Andrew Hamilton
    - name: gholms
    - name: Greg Swift
    - name: inoX-tech GmbH
      url: https://www.inox-tech.de/cms/index.php
    - name: Jason M. Graham
    - name: Mark Hinkle
    - name: Marten M.
    - name: Martin Zehetmayer
    - name: Nathan Milford
  - name: Silver
    items:
    - name: James Bartus
  - name: Bronze
    items:
    - name: Robert Cochran
    - name: smooge
  - name: Other
    items:
    - name: tshubitz
---
Cobbler conducted a [fundraising campaign](http://www.indiegogo.com/cobbler24) during Nov-Dec of 2012, in order to raise money to help pay for additional hardware to be used to aid in adding new features such as a dedicated CI server (jenkins) and the ability to deploy images built by Cobbler into IaaS platforms such as Eucalyptus, Openstack, etc.

The following is the list of those who generously contributed:

{% for contrib in page.contributors %}
<h2>{{ contrib.name }} Supporters</h2>
 {% for c in contrib.items %}
 {{ c.name }}
 {% endfor %}
{% endfor %}

Please note, this page is a bit of a place holder for now, and will be enhanced in the near future.
