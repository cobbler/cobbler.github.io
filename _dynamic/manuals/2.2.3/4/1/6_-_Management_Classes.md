---
layout: manpage
title: Cobbler Primatives - Management Classes
meta: 2.2.3
---
## MANAGEMENT CLASSES
Management classes allows cobbler to function as an configuration management system. Cobbler currently supports the following resource types:

       1. Packages
       2. Files

       Resources are executed in the order listed above.

{% highlight bash %}
$ cobbler mgmtclass add --name=string --comment=string [--packages=list] [--files=list]
{% endhighlight %}

### name
The name of the mgmtclass. Use this name when adding a management class to a system, profile, or distro. To add a mgmtclass to an existing system use something like (cobbler system edit --name="madhatter" --mgmt-classes="http mysql").

### comment
A comment that describes the functions of the management class.

### packages
Specifies a list of package resources required by the management class.

### files
Specifies a list of file resources required by the management class.