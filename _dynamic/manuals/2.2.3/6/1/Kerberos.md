---
layout: manpage
title: Cobbler Manual
---
## About

Do you want to authenticate users using Cobbler's Web UI against
Kerberos? If so, this is for you.

You may also be interested in authenticating against LDAP instead
-- see [LDAP](Ldap) -- though if you have Kerberos you probably want to use Kerberos.

We assume you've already got the WebUI up and running and just want
to kerberize it ... if not, see
[Cobbler web interface](Cobbler web interface) first, then come back
here.

## Bonus

These steps also work for kerberizing Cobbler XMLRPC transactions
provided those URLs are the Apache proxied versions as specified in
/var/lib/cobbler/httpd.conf

## Configure the Authentication and Authorization Modes

Edit /etc/cobbler/modules.conf:

    [authentication]
    module = authn_passthru
    
    [authorization]
    module = authz_allowall

Note that you may want to change the authorization later, see
[Web Authorization](Web Authorization)
for more info.

## A Note About Security

The authn\_passthru mode is only as secure as your Apache
configuraton. If you make the Apache configuration permit everyone
now, everyone will have access. For this reason you may want to
test your Apache config on a test path like "/var/www/html/test"
first, before using those controls to replace your default cobbler
controls.

## Configure your /etc/krb5.conf

NOTE: This is based on my file which I created during testing. Your
kerberos configuration could be rather different.

    [logging]
     default = FILE:/var/log/krb5libs.log
     kdc = FILE:/var/log/krb5kdc.log
     admin_server = FILE:/var/log/kadmind.log
    
    [libdefaults]
     ticket_lifetime = 24000
     default_realm = EXAMPLE.COM
     dns_lookup_realm = false
     dns_lookup_kdc = false
     kdc_timesync = 0
    
    [realms]
     REDHAT.COM = {
      kdc = kdc.example.com:88
      admin_server = kerberos.example.com:749
      default_domain = example.com
     }
    
    [domain_realm]
     .example.com = EXAMPLE.COM
     example.com = EXAMPLE.COM
    
    [kdc]
     profile = /var/kerberos/krb5kdc/kdc.conf
    
    [pam]
     debug = false
     ticket_lifetime = 36000
     renew_lifetime = 36000
     forwardable = true
     krb4_convert = false
    

## Modify your Apache configuration file

There's a section in /etc/httpd/conf.d/cobbler.conf that controls
access to "/var/www/cobbler/web". We are going to modify that
section. Replace that specific "Directory" section with:

(Note that for Cobbler \>= 2.0, the path is actually
"/cobbler\_web/")

    LoadModule auth_kerb_module   modules/mod_auth_kerb.so
    
    <Directory "/var/www/cobbler/web/">
      SetHandler mod_python
      PythonHandler index
      PythonDebug on
    
      Order deny,allow
      Deny from all
      AuthType Kerberos
      AuthName "Kerberos Login"
      KrbMethodK5Passwd On
      KrbMethodNegotiate On
      KrbVerifyKDC Off
      KrbAuthRealms EXAMPLE.COM
    
      <Limit GET POST>
        require user \
          gooduser1@EXAMPLE.COM \
          gooduser2@EXAMPLE.COM
        Satisfy any
      </Limit>
    
    </Directory>
    

Note that the above example configuration can be tweaked any way
you want, the idea is just that we are delegating Kerberos
authentication bits to Apache, and Apache will do the hard work for
us.

Also note that the above information lacks KeyTab and Service Principal info for
usage with the GSS API (so you don't have to type passwords in). If
you want to enable that, do so following whatever kerberos
documentation you like -- Cobbler is just deferring to Apache for
auth so you can do whatever you want. The above is just to get you
started.

## Restart Things And test

    /sbin/service cobblerd restart
    /sbin/service httpd restart

## A Note About Usernames

If entering usernames and passwords into prompts, use
"user@EXAMPLE.COM" not "user".

If you are using one of the authorization mechanisms that uses
/etc/cobbler/users.conf, make sure these match and that you do not
use just the short form.

## Customizations

You may be interested in the [Web Authorization](Web Authorization)
section to further control things. For instance you can decide to let in
the users above, but only allow certain users to access certain
things. The authorization module can be used independent of your
choice of authentication modes.

## A note about restarting cobblerd

Cobblerd regenerates an internal token on restart (for security
reasons), so if you restart cobblerd, you'll have to close your
browser to drop the session token and then try to login again.
Generally you won't be restarting cobblerd except when restarting
machines and on upgrades, so this shouldn't be a problem.

