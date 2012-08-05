---
layout: manpage
title: Package Resources
meta: 2.2.3
---
Package resources are managed using cobbler package add, allowing you to install and uninstall packages on a system outside of your install process.

## Actions

### install
Install the package. [Default]

### uninstall
Uninstall the package.

## Attributes

### installer
Which package manager to use, vaild options [rpm|yum].

### version
Which version of the package to install.

#### Example:
{% highlight bash %}
$ cobbler package add --name=string --comment=string [--action=install|uninstall] --installer=string \
[--version=string]
{% endhighlight %}