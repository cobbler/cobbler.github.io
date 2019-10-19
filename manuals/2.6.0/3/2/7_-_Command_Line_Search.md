---
layout: manpage
title: Command Line Search
meta: 2.6.0
nav: 7 - Command Line Search
navversion: nav26
---

Command line search can be used to ask questions about your cobbler configuration, rather than just having to run
`cobbler list` or `cobbler report` and scanning through the results. ([The Cobbler Web Interface]() also supports
search/filtering, for those that want to use it, though that is not documented on this page)

Command line search works on all distro/profile/system/and repo objects.

{% highlight bash %}
$ cobbler distro find --help
$ cobbler profile find --help
$ cobbler system find --help
$ cobbler repo find --help
{% endhighlight %}

NOTE: Some of these examples are kind of arbitrary. I'm sure you can think of some more real world examples.

## Examples

Find what system record has a given mac address: `$ cobbler system find --mac=AA:BB:CC:DD:EE:FF`

If anything is using a certain kernel, delete that object and all it's children (profiles, systems, etc).

{% highlight bash %}
$ cobbler distro find --kernel=/path/to/kernel | xargs -n1 --replace cobbler distro remove --name={} --recursive
{% endhighlight %}

What profiles use the repo "epel-5-i386-testing"?

{% highlight bash %}
$ cobbler profile find --repos=epel-5-i386-testing
{% endhighlight %}

Which profiles are owned by neo AND mranderson?

{% highlight bash %}
$ cobbler profile find --owners="neo,mranderson" # lists need to be comma delimited, like this, with no unneeded spaces
{% endhighlight %}

What systems are set to pass the kernel argument "color=red" ?

{% highlight bash %}
$ cobbler system find --kopts="color=red"
{% endhighlight %}

What systems are set to pass the kernel argument `color=red` and `number=5`?

{% highlight bash %}
$ cobbler system find --kopts="color=red number=5" # space delimited key value pairs key1=value1 key2 key3=value3
{% endhighlight %}

What systems set the kickstart metadata variable of foo to the value 'bar' ?

{% highlight bash %}
$ cobbler system find --ksmeta="foo=bar" # space delimited key value pairs again
{% endhighlight %}

What systems are set to netboot disabled? Note: This also accepts 'false', or 'no'.

{% highlight bash %}
$ cobbler system find --netboot-enabled=0
{% endhighlight %}

For all systems that are assigned to profile "foo" that are set to netboot disabled, enable them. Demonstrates an "AND"
query combined with xargs usage.

{% highlight bash %}
$ cobbler system find --profile=foo --netboot-enabled=0 | xargs -n1 --replace cobbler system edit --name={} --netboot-enabled=1
{% endhighlight %}

## A Note About Types And Wildcards

Though the cobbler objects behind the scenes store data in various different formats (booleans, hashes, lists, strings),
it all works fom the command line as text.

If multiple terms are specified to one argument, the search is an "AND" search.

If multiple parameters are specified, the search is still an "AND" search.

The find command understands patterns such as "*" and "?". This is supported using Python's fnmatch.

To learn more: `pydoc fnmatch.fnmatch`

All systems starting with the string foo: `cobbler system find --name="foo*"`

This is rather useful when combined with xargs. This is a rather tame example, reporting on all systems starting with
"TEST".

{% highlight bash %}
cobbler system find --name="TEST*" | xargs -n1 --replace cobbler system report --name={}
{% endhighlight %}

By extension, you could use this to toggle the `--netboot-enabled` systems of machines with certain hostnames, mac
addresses, and so forth, or perform other kinds of wholesale edits (for instance, deletes, or assigning profiles with
certain names to new distros when upgrading them from F8 to F9, for instance).

## API Usage

All of this functionality is also exposed through the API.

{% highlight python %}
#!/usr/bin/python
import cobbler.api as capi
api_handle = capi.BootAPI()
matches = api_handle.find_profile(name="TEST*",return_list=True)
print matches
{% endhighlight %}


You will find uses of ".find()" throughout the cobbler code that make use of this behavior.
