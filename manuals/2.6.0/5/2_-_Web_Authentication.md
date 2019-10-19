---
layout: manpage
title: Web Authentication
meta: 2.6.0
nav: 2 - Web Authentication
navversion: nav26
---

<p>Authentication controls who has access to your cobbler server. Controlling the details of what they can subsequently do is covered by a second step, <a href="Web%20Authorization">Web Authorization</a>.</p>

<p>Authentication is governed by a setting in the <code>[authentication]</code> section of <code>/etc/cobbler/modules.conf</code>, whose options are as follows:</p>

<h2>Deny All (Default)</h2>

<pre><code>[authentication]
module = authn_denyall
</code></pre>

<p>This disables all external XMLRPC modifications, and also disables the Cobbler Web interface.   Use this if you do not want to allow any external access and do not want
to use the web interface.  This is the default setting in Cobbler for new installations, forcing users to decide what sort of remote security they want to have, and is intended to make sure they think about that decision, rather than having access on by default.</p>

<h2>Digest</h2>

<pre><code>[authentication]
module = authn_configfile
</code></pre>

<p>This option uses a simple digest file to hold username and password information.  This is a great option if you do not have a Kerberos or LDAP server to authenticate against and just want something simple.</p>

<p>Be sure to change your default password for the "cobbler" user as soon as you set this up:</p>

<pre><code>htdigest /etc/cobbler/users.digest "Cobbler" cobbler
</code></pre>

<p>You can add additional users:</p>

<pre><code>htdigest /etc/cobbler/users.digest "Cobbler" $username
</code></pre>

<p>You can also choose to delete the "cobbler" user from the file.</p>

<h2>Defer to Apache / Kerberos</h2>

<pre><code>[authentication]
module = authn_passthru
</code></pre>

<p>This option lets Apache do the authentication and Cobbler will defer to what it decides.  This is how Cobbler implements <a href="Kerberos">Kerberos</a> support. This could be modified to use other mechanisms if so desired.</p>

<h2>LDAP</h2>

<pre><code>[authentication]
module = authn_ldap
</code></pre>

<p>This option authenticates against <a href="LDAP">LDAP</a> using parameters from <code>/etc/cobbler/settings</code>. This is a direct connection to LDAP without relying on Apache.</p>

<h2>Spacewalk</h2>

<pre><code>[authentication]
module = authn_spacewalk
</code></pre>

<p>This module allows http://fedorahosted.org/spacewalk to use its own specific authorization scheme to log into Cobbler, since Cobbler is a software service used by Spacewalk.</p>

<p>There are settings in <code>/etc/cobbler/settings</code> to configure this, for instance redhat_management_permissive if set to 1 will enable users with admin rights in Spacewalk (or RHN Satellite Server) to access Cobbler web using the same username/password combinations.</p>

<p>This module requires that the address of the Spacewalk/Satellite server is configured in <code>/etc/cobbler/settings</code> (redhat_management_server)</p>

<h2>Testing</h2>

<pre><code>[authentication]
module = authn_testing
</code></pre>

<p>This is for development/debug only and should never be used in production systems.  The user "testing/testing" is always let in, and no other combinations are accepted.</p>

<h2>User Supplied</h2>

<p>Copy the signature of any existing cobbler authentication <a href="Modules">module</a> to write your own that conforms to your organization's specific security requirements.
Then just reference that module name in <code>/etc/cobbler/modules.conf</code>, restart cobblerd, and you're good to go.</p>
