---
layout: manpage
title: Tips For RHN
meta: 2.6.0
nav: C - Tips for RHN
navversion: nav26
---

<p>If you're deploying RHEL, there are a few extra kickstart and Cobbler tricks you can employ to make provisioning a snap, all consolidated in one place...</p>

<h3>Importing</h3>

<p>Download the DVD ISO's for RHN hosted.</p>

<p>Then use "cobbler import" to import the ISO's to get an install tree.</p>

<h3>Registering To RHN</h3>

<p>RHEL has a tool installed called rhnreg_ks that you may not be familiar with. It's what you call in the %post of a kickstart file to make a system automatically register itself with Satellite or the RHN Hosted offering.</p>

<p>You may want to read up on rhnreg_ks for all the options it provides, but Cobbler ships with a snippet ("redhat_register") that can help you register systems. It should be in the <code>/var/lib/cobbler/kickstarts/sample*.ks</code> files by default, for you to look at. It is configured by various settings in <code>/etc/cobbler/settings</code>.</p>

<h3>Authenticating XMLRPC/Web users against Satellite / Spacewalk's API</h3>

<p>In <code>/etc/cobbler/modules.conf</code>, if you are using authn_spacewalk for authentication, Cobbler can talk to Satellite (5.3 and later) or Spacewalk for authentication. Authentication is cleared when users have the role "org_admin", or "kickstart_admin" roles. Authorization can later be supplied via cobbler modules as normal, for example, authz_allowall (default) or authn_ownership, but should probably be left as authz_allowall.</p>

<p>See CustomizableSecurity</p>

<p>If you are using a copy of Cobbler that came bundled with Spacewalk or Satellite Server, don't change these settings, as you will break Spacewalk/Satellite's ability to converse with Cobbler.</p>

<h3>Installation Numbers</h3>

<p>See the section called "RHEL Keys" on the KickstartSnippets page. It's a useful way to store all of your install keys in cobbler and use them automatically as needed.</p>

<h3>Repository Mirroring</h3>

<p>Cobbler has limited/experimental support for mirroring RHN-channels, see the cobbler manpage for details. Basically you just specify a "cobbler repo add" with the path "rhn://channel-name". This requires a version of yum-utils 1.0.4 or later, installed on the cobbler boot server. Only the arch of the cobbler server can be mirrored. See ManageYumRepos.</p>

<p>If you require better mirroring support than what yum provides, please consider Red Hat Satellite Server.</p>

<h3>Other Tricks</h3>

<p>Feel free to add your own here!</p>
