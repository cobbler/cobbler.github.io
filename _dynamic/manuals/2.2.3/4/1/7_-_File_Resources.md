---
layout: manpage
title: Cobbler Primatives - File Resources
meta: 2.2.3
---
## MANAGEMENT RESOURCES

Resources are the lego blocks of configuration management. Resources are grouped together via Management Classes, which are then linked to a system. Cobbler supports two (2) resource types. Resources are configured in the order listed below.

       1. Packages
       2. Files

## FILE RESOURCES
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

#### Examples:
{%  highlight bash %}       
$ cobbler file add --name=string --comment=string [--action=string] --mode=string --group=string \
--user=string --path=string [--template=string]
{% endhighlight %}
