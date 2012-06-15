---
layout: manpage
title: Cobbler Manual
---
If you're deploying RHEL, there are a few extra kickstart and Cobbler tricks you can employ to make provisioning a snap, all consolidated in one place...

### Importing

Download the DVD ISO's for RHN hosted.

Then use "cobbler import" to import the ISO's to get an install tree.

### Registering To RHN

RHEL has a tool installed called rhnreg_ks that you may not be familiar with. It's what you call in the %post of a kickstart file to make a system automatically register itself with Satellite or the RHN Hosted offering.

You may want to read up on rhnreg_ks for all the options it provides, but Cobbler ships with a snippet ("redhat_register") that can help you register systems. It should be in the /var/lib/cobbler/kickstarts/sample*.ks files by default, for you to look at. It is configured by various settings in /etc/cobbler/settings

### Authenticating XMLRPC/Web users against Satellite / Spacewalk's API

In /etc/cobbler/modules.conf, if you are using authn_spacewalk for authentication, Cobbler can talk to Satellite (5.3 and later) or Spacewalk for authentication. Authentication is cleared when users have the role "org_admin", or "kickstart_admin" roles. Authorization can later be supplied via cobbler modules as normal, for example, authz_allowall (default) or authn_ownership, but should probably be left as authz_allowall.

See CustomizableSecurity

If you are using a copy of Cobbler that came bundled with Spacewalk or Satellite Server, don't change these settings, as you will break Spacewalk/Satellite's ability to converse with Cobbler.

### Installation Numbers

See the section called "RHEL Keys" on the KickstartSnippets page. It's a useful way to store all of your install keys in cobbler and use them automatically as needed.

### Repository Mirroring

Cobbler has limited/experimental support for mirroring RHN-channels, see the cobbler manpage for details. Basically you just specify a "cobbler repo add" with the path "rhn://channel-name". This requires a version of yum-utils 1.0.4 or later, installed on the cobbler boot server. Only the arch of the cobbler server can be mirrored. See ManageYumRepos.

If you require better mirroring support than what yum provides, please consider Red Hat Satellite Server.

### Other Tricks

Feel free to add your own here!