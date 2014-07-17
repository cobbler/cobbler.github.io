---
layout: manpage
title: Modules Configuration
meta: 2.6.0
---

Cobbler supports add-on modules, some of which can provide the same functionality (for instance, the authentication/authorization modules discussed in the {% linkup title:"Web Authentication" extrameta:2.6.0 %} section). Modules of this nature are configured via the `/etc/cobbler/modules.conf file`, for example:

{% highlight ini %}
# dns:
# chooses the DNS management engine if manage_dns is enabled
# in /etc/cobbler/settings, which is off by default.
# choices:
#    manage_bind    -- default, uses BIND/named
#    manage_dnsmasq -- uses dnsmasq, also must select dnsmasq for dhcp below

[dns]
module = manage_bind
{% endhighlight %}

As you can see above, this file has a typical INI-style syntax where sections are denoted with the **\[\]** brackets and entries are of the form **"key = value"**.

Many of these sections are covered in the {% linkup title:"Managing Services With Cobbler" extrameta:2.6.0 %} and {% linkup title:"Web Authentication" extrameta:2.6.0 %} topics later in this manual. Please refer to those sections for further details on modifying this file.

As with the settings file, you must restart cobblerd after making changes to this file.
