---
layout: manpage
title: Passthru Authentication
meta: 2.8.0
---
Passthru authentication has been added back to Cobbler Web as of version 2.8.0. Passthru authentication allows you to
setup your webserver to perform authentication and Cobbler Web will use the value of REMOTE_USER to determine
authorization. Using this authentication module disables the normal web form authentication which was added in Cobbler
Web 2.2.0. If you prefer to use web form authentication we recommend using PAM or one of the other authentication
schemes.

A common reason you might want to use Passthru authentication is to provide support for single sign on authentication
like Kerberos. An example of setting this up can be found
[here](http://linux3.julienfamily.com/manuals/2.8.0/6/2/3_-_Kerberos.htmlhere).
