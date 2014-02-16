---
layout: manpage
title: Cobbler Manual
meta: 2.4.0
---
As mentioned at [KickstartTemplating](/cobbler/wiki/KickstartTemplating), Cobbler
uses Cheetah for it's templating system.  (It also wants to support other choices
and may in the future support others).

It is possible to add new functions to the templating engine, much
like [KickstartSnippets](/cobbler/wiki/KickstartSnippets), that
provide the ability to do macro-based things in the template. If
you are new to Cheetah, see the documentation at
[http://www.cheetahtemplate.org/learn.html](http://www.cheetahtemplate.org/learn.html)
and pay special attention to the \#def directive.

To create new functions, add your Cheetah code to
`/etc/cobbler/cheetah_macros`. This file will be sourced in all
Cheetah templates automatically, making it possible to write custom
functions and use them from this file.

You will want to restart cobblerd after changing the macros file.

## User Shared Functions

Users can share examples of functions they have written below:

-   Fill in

