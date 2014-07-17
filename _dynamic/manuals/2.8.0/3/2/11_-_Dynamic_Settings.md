---
layout: manpage
title: Dynamic Settings CLI Command
meta: 2.6.0
---
The CLI command for dynamic settings has two sub-commands:

{% highlight bash %}
$ cobbler setting --help
usage
=====
cobbler setting edit
cobbler setting report
{% endhighlight %}

### cobbler setting edit

This command allows you to modify a setting on the fly. It takes affect immediately, however depending on the setting you change, a "cobbler sync" may be required afterwards in order for the change to be fully applied.

This syntax of this command is as follows:

{% highlight bash %}
$ cobbler setting edit --name=option --value=value
{% endhighlight %}

As with other cobbler primitives, settings that are array-based should be space-separated while hashes should be a space-separated list of key=value pairs.

### cobbler setting report

This command prints a report of the current settings. The syntax of this command is as follows:

{% highlight bash %}
$ cobbler setting report [--name=option]
{% endhighlight %}

The list of settings can be limited to a single setting by specifying the --name option.
