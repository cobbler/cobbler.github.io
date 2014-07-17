---
layout: manpage
title: Web Authentication
meta: 2.6.0
---

Authentication controls who has access to your cobbler server. Controlling the details of what they can subsequently do is covered by a second step, [Web Authorization](Web Authorization).

Authentication is governed by a setting in the `[authentication]` section of `/etc/cobbler/modules.conf`, whose options are as follows:

## Deny All (Default) 

    [authentication]
    module = authn_denyall


This disables all external XMLRPC modifications, and also disables the Cobbler Web interface.   Use this if you do not want to allow any external access and do not want
to use the web interface.  This is the default setting in Cobbler for new installations, forcing users to decide what sort of remote security they want to have, and is intended to make sure they think about that decision, rather than having access on by default.

## Digest

    [authentication]
    module = authn_configfile

This option uses a simple digest file to hold username and password information.  This is a great option if you do not have a Kerberos or LDAP server to authenticate against and just want something simple.

Be sure to change your default password for the "cobbler" user as soon as you set this up:

    htdigest /etc/cobbler/users.digest "Cobbler" cobbler
   
You can add additional users:

    htdigest /etc/cobbler/users.digest "Cobbler" $username

You can also choose to delete the "cobbler" user from the file.

## Defer to Apache / Kerberos

    [authentication]
    module = authn_passthru

This option lets Apache do the authentication and Cobbler will defer to what it decides.  This is how Cobbler implements [Kerberos](Kerberos) support. This could be modified to use other mechanisms if so desired.

## LDAP

    [authentication]
    module = authn_ldap

This option authenticates against [LDAP](LDAP) using parameters from `/etc/cobbler/settings`. This is a direct connection to LDAP without relying on Apache.

## Spacewalk

    [authentication]
    module = authn_spacewalk

This module allows http://fedorahosted.org/spacewalk to use its own specific authorization scheme to log into Cobbler, since Cobbler is a software service used by Spacewalk.

There are settings in `/etc/cobbler/settings` to configure this, for instance redhat_management_permissive if set to 1 will enable users with admin rights in Spacewalk (or RHN Satellite Server) to access Cobbler web using the same username/password combinations.  

This module requires that the address of the Spacewalk/Satellite server is configured in `/etc/cobbler/settings` (redhat_management_server)

## Testing

    [authentication]
    module = authn_testing

This is for development/debug only and should never be used in production systems.  The user "testing/testing" is always let in, and no other combinations are accepted.

## User Supplied

Copy the signature of any existing cobbler authentication [module](Modules) to write your own that conforms to your organization's specific security requirements.
Then just reference that module name in `/etc/cobbler/modules.conf`, restart cobblerd, and you're good to go.
