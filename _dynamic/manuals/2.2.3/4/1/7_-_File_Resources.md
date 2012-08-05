---
layout: manpage
title: File Resources
meta: 2.2.3
---
File resources are managed using cobbler file add, allowing you to create and delete files on a system.

## Actions

### create
Create the file. [Default]

### remove
Remove the file.

## Attributes

### mode
Permission mode (as in chmod).

### group
The group owner of the file.

### user
The user for the file.

### path
The path for the file.

### template
The template for the file.

#### Example:
{%  highlight bash %}       
$ cobbler file add --name=string --comment=string [--action=string] --mode=string --group=string \
--user=string --path=string [--template=string]
{% endhighlight %}
