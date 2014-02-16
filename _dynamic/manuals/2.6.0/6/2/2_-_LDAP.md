---
layout: manpage
title: LDAP Authentication
meta: 2.4.0
---

By default, the Cobbler WebUI and Web services authenticate against
a digest file. All users in the digest file are "in". What if you
want to authenticate against an external resource? Cobbler can do
that too. These instructions can be used to make it authenticate
against LDAP instead.

For the purposes of these instructions, we are authenticating
against a new source install of FreeIPA -- though any LDAP install
should work in the same manner.

## Instructions

\0. Install python-ldap

    yum install python-ldap

\1. In `/etc/cobbler/modules.conf` change the authn/authz sections to
 look like:

    
    [authentication]
    module = authn_ldap
    
    [authorization]
    module = authz_configfile
                                

The above specifies that you authenticating against LDAP and will
list which LDAP users are valid by looking at
`/etc/cobbler/users.conf`.

\2. In `/etc/cobbler/settings`, set the following to appropriate
 values to configure the LDAP parts. The values below are examples
 that show us pointing to an LDAP server, which is not running on
 the cobbler box, for authentication. Note that authorization is
 seperate from authentication. We'll get to that later.

    
    ldap_server     : "grimlock.devel.redhat.com"
    ldap_base_dn    : "DC=devel,DC=redhat,DC=com"
    ldap_port       : 389
    ldap_tls        : 1

With Cobbler 1.3 and higher, you can add additional LDAP servers by
separating the server names with a space in the ldap\_server
field.

\3. Now we have to configure OpenLDAP to know about the cert of the
 LDAP server. You only have to do this once on the cobbler box, not
 on each client box.

    openssl s_client -connect servername:636

\4. Copy everything between BEGIN and END in the above output to `/etc/openldap/cacerts/ldap.pem`

\5. Ensure that the CA certificate is correctly hashed

    cd /etc/openldap/cacerts
    
    ln -s ldap.pem $(openssl x509 -hash -noout -in ldap.pem).0

On Red Hat and Fedora systems this can also be done using the
cacertdir\_rehash command:

    cacertdir_rehash /etc/openldap/cacerts

\6. Configure `/etc/openldap/ldap.conf` to include the following:

    TLS_CACERTDIR   /etc/openldap/cacerts
    TLS_REQCERT     allow

\7. Edit `/etc/cobbler/users.conf` to include the list of users
 allowed access to cobbler resources. These must match names in
 LDAP. The group names are just comments.

    [dxs]
    mac = ""
    pete = ""
    jack = ""

\8. Done! Cobbler now authenticates against ldap instead of the
 digest file, and you can limit what users can edit things by
 changing the `/etc/cobbler/users.conf` file.

## Troubleshooting LDAP

The following trick lets you test your username/password
combinations outside of the web app and may prove useful in
verifying that your LDAP configuration is correct. replace $VERSION
with your python version, for instance 2.4 or 2.5, etc.

    # cp /usr/lib/python$VERSION/site-packages/cobbler/demo_connect.py /tmp/demo_connect.py
    # python /tmp/demo_connect.py --user=username --pass=password

Just run the above and look at the output. You should see a
traceback if problems are encountered, which may point to problems
in your configuration if you specified a valid username/password.
Restart cobblerd after changing `/etc/cobbler/settings` (if you're not using {% linkup title:"Dynamic Settings" extrameta:2.4.0 %}) in order for
them to take effect.

