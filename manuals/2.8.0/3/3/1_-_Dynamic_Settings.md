---
layout: manpage
title: Dynamic Settings
meta: 2.8.0
---
Prior to Cobbler 2.4.0, any changes to `/etc/cobbler/settings` required a restart of the cobblerd daemon for those
changes to take affect. Now, with 2.4.0+, you can easily modify settings on the fly via the "cobbler setting" command.

### Enabling Dynamic Settings

Dynamic settings are not enabled by default. In order to enable them, you must set "allow_dynamic_settings: 1" in
`/etc/cobbler/settings` and restart cobblerd. 

### Caveats

Over the years, the Cobbler settings file has grown organically, and as such has not always had consistent spacing
applied to the YAML entries it contains. In order to ensure that augeas can correctly rewrite the settings, you must run
the following sed command:

{% highlight bash %}
$ sed -i 's/^[[:space:]]\+/ /' /etc/cobbler/settings
{% endhighlight %}

When dynamic settings are enabled, the "cobbler check" command will also print out this recommendation.

### CLI Commands

Please see the [Dynamic Settings CLI Command]({% link manuals/2.8.0/3/2/11_-_Dynamic_Settings.md %}) section for details
on the dynamic settings commands.
