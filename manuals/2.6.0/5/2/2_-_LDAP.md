
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/5_-_Web_Interface.html">5</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/5/2_-_Web_Authentication.html">2</a> <span class="divider">/</span></li><li class="active">LDAP Authentication</li></ul>
   <h1>LDAP Authentication</h1>
<p>By default, the Cobbler WebUI and Web services authenticate against
a digest file. All users in the digest file are "in". What if you
want to authenticate against an external resource? Cobbler can do
that too. These instructions can be used to make it authenticate
against LDAP instead.</p>

<p>For the purposes of these instructions, we are authenticating
against a new source install of FreeIPA -- though any LDAP install
should work in the same manner.</p>

<h2>Instructions</h2>

<p>\0. Install python-ldap</p>

<pre><code>yum install python-ldap
</code></pre>

<p>\1. In <code>/etc/cobbler/modules.conf</code> change the authn/authz sections to
 look like:</p>

<pre><code>[authentication]
module = authn_ldap

[authorization]
module = authz_configfile
</code></pre>

<p>The above specifies that you authenticating against LDAP and will
list which LDAP users are valid by looking at
<code>/etc/cobbler/users.conf</code>.</p>

<p>\2. In <code>/etc/cobbler/settings</code>, set the following to appropriate
 values to configure the LDAP parts. The values below are examples
 that show us pointing to an LDAP server, which is not running on
 the cobbler box, for authentication. Note that authorization is
 seperate from authentication. We'll get to that later.</p>

<pre><code>ldap_server     : "grimlock.devel.redhat.com"
ldap_base_dn    : "DC=devel,DC=redhat,DC=com"
ldap_port       : 389
ldap_tls        : 1
</code></pre>

<p>With Cobbler 1.3 and higher, you can add additional LDAP servers by
separating the server names with a space in the ldap_server
field.</p>

<p>\3. Now we have to configure OpenLDAP to know about the cert of the
 LDAP server. You only have to do this once on the cobbler box, not
 on each client box.</p>

<pre><code>openssl s_client -connect servername:636
</code></pre>

<p>\4. Copy everything between BEGIN and END in the above output to <code>/etc/openldap/cacerts/ldap.pem</code></p>

<p>\5. Ensure that the CA certificate is correctly hashed</p>

<pre><code>cd /etc/openldap/cacerts

ln -s ldap.pem $(openssl x509 -hash -noout -in ldap.pem).0
</code></pre>

<p>On Red Hat and Fedora systems this can also be done using the
cacertdir_rehash command:</p>

<pre><code>cacertdir_rehash /etc/openldap/cacerts
</code></pre>

<p>\6. Configure <code>/etc/openldap/ldap.conf</code> to include the following:</p>

<pre><code>TLS_CACERTDIR   /etc/openldap/cacerts
TLS_REQCERT     allow
</code></pre>

<p>\7. Edit <code>/etc/cobbler/users.conf</code> to include the list of users
 allowed access to cobbler resources. These must match names in
 LDAP. The group names are just comments.</p>

<pre><code>[dxs]
mac = ""
pete = ""
jack = ""
</code></pre>

<p>\8. Done! Cobbler now authenticates against ldap instead of the
 digest file, and you can limit what users can edit things by
 changing the <code>/etc/cobbler/users.conf</code> file.</p>

<h2>Troubleshooting LDAP</h2>

<p>The following trick lets you test your username/password
combinations outside of the web app and may prove useful in
verifying that your LDAP configuration is correct. replace $VERSION
with your python version, for instance 2.4 or 2.5, etc.</p>

<pre><code># cp /usr/lib/python$VERSION/site-packages/cobbler/demo_connect.py /tmp/demo_connect.py
# python /tmp/demo_connect.py --user=username --pass=password
</code></pre>

<p>Just run the above and look at the output. You should see a
traceback if problems are encountered, which may point to problems
in your configuration if you specified a valid username/password.
Restart cobblerd after changing <code>/etc/cobbler/settings</code> (if you're not using <a href="/manuals/2.6.0/3/3/1_-_Dynamic_Settings.html">Dynamic Settings</a>) in order for
them to take effect.</p>
