---
layout: manpage
title: Cobbler Primatives - Package Resources
meta: 2.2.3
---
## MANAGEMENT RESOURCES

Resources are the lego blocks of configuration management. Resources are grouped together via Management Classes, which are then linked to a system. Cobbler supports two (2) resource types. Resources are configured in the order listed below.

       1. Packages
       2. Files

## PACKAGE RESOURCES
Package resources are managed using cobbler package add

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

#### Examples:
{% highlight bash %}
$ cobbler package add --name=string --comment=string [--action=install|uninstall] --installer=string \
[--version=string]
{% endhighlight %}