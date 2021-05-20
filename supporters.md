---
layout: default
title: Cobbler Supporters
---

# Cobbler Supporters

Cobbler conducted a [fundraising campaign](https://www.indiegogo.com/projects/cobbler-2-4-0-and-beyond#/) during
Nov-Dec of 2012, in order to raise money to help pay for additional hardware to be used to aid in adding new features
such as a dedicated CI server (Jenkins) and the ability to deploy images built by Cobbler into IaaS platforms such as
Eucalyptus, Openstack, etc.

**Update from 2018/19:** Many thanks also to SUSE who dedicated devs porting cobbler from Python 2 to Python 3!

The following is the list of those who generously contributed:

{% for contrib in site.data.contributors %}
<h2>{{ contrib.name }} Supporters</h2>
 <ul>
 {% for c in contrib.items %}
   <li>{{ c.name }}</li>
 {% endfor %}
 </ul>
{% endfor %}

Please note, this page is a bit of a place holder for now, and will be enhanced in the near future.
