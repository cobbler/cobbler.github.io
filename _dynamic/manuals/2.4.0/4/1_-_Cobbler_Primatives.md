---
layout: manpage
title: Cobbler Primatives
meta: 2.4.0
---

Primatives are the building blocks Cobbler uses to represent builds, as outlined in the "How We Model Things" section of the {% linkup title:"Introduction to Cobbler" extrameta:2.4.0 %} page. These objects are generally loosely related, though the distro/profile/system relation is somewhat more strict.

This section covers the creation and use of these objects, as well as how they relate to each other - including the methodology by which attributes are inherited from parent objects.

## Standard Rules

Cobbler has a standard set of rules for manipulating primative field values and, in the case of distros/profiles/systems, how those values are inherited from parents to children.

### Inheritance of Values

Inheritance of values is based on the field type. 

* For regular fields and arrays, the value will only be inherited if the field is set to '&lt;&lt;inherit&gt;&gt;'. Since distros and other objects like repos do not have a parent, these values are inherited from the defaults in {% linkup title:"Cobbler Settings" extrameta:2.4.0 %}. If the field is specifically set to an empty string, no value will be inherited.
* For hashes, the values from the parent will always be inherited and blended with the child values. If the parent and child have the same key, the child's values will win an override the parent's.

### Array Fields
Some fields in Cobbler (for example, the --name-servers field) are stored as arrays. These arrays are always considered arrays of strings, and are always specified in Cobbler as a space-separated list when using add/edit.

**Example:**

{% highlight bash %}
$ cobbler [object] edit --name=foo --field="a b c d"
{% endhighlight %}

### Hash Fields (key=value)
Other fields in Cobbler (for example, the --ksmeta field) are stored as hashes - that is a list of key=value pairs. As with arrays, both the keys and values are always interpreted as strings.

#### Preserving Values When Editing

By default, any time a hash field is manipulated during an edit, the contents of the field are replaced completely with the new values specified during the edit.

**Example:**

{% highlight bash %}
$ cobbler distro edit --name=foo --ksmeta="a=b c=d"
$ cobbler distro report --name=foo | grep "Kickstart Meta"
Kickstart Metadata             : {'a': 'b', 'c': 'd'}
$ cobbler distro edit --name=foo --ksmeta="e=f"
$ cobbler distro report --name=foo | grep "Kickstart Meta"
Kickstart Metadata             : {'e': 'f'}
{% endhighlight %}

To preserve the contents of these fields, --in-place should be specified:

{% highlight bash %}
$ cobbler distro edit --name=foo --ksmeta="a=b c=d"
$ cobbler distro report --name=foo | grep "Kickstart Meta"
Kickstart Metadata             : {'a': 'b', 'c': 'd'}
$ cobbler distro edit --name=foo --in-place --ksmeta="e=f"
$ cobbler distro report --name=foo | grep "Kickstart Meta"
Kickstart Metadata             : {'a': 'b', 'c': 'd', 'e': 'f'}
{% endhighlight %}

#### Removing Values

To remove a single value from the hash, use the '~' (tilde) character along with --in-place:

{% highlight bash %}
$ cobbler distro edit --name=foo --ksmeta="a=b c=d"
$ cobbler distro report --name=foo | grep "Kickstart Meta"
Kickstart Metadata             : {'a': 'b', 'c': 'd'}
$ cobbler distro edit --name=foo --in-place --ksmeta='~a'
$ cobbler distro report --name=foo | grep "Kickstart Meta"
Kickstart Metadata             : {'c': 'd'}
{% endhighlight %}

#### Suppressing Values

You can also suppress values from being used, by specifying the '-' character in front of the key name:

{% highlight bash %}
$ cobbler distro edit --name=foo --ksmeta="a=b c=d"
$ cobbler distro report --name=foo | grep "Kickstart Meta"
Kickstart Metadata             : {'a': 'b', 'c': 'd'}
$ cobbler distro edit --name=foo --in-place --ksmeta='-a'
$ cobbler distro report --name=foo | grep "Kickstart Meta"
Kickstart Metadata             : {'-a': 'b', 'c': 'd'}
{% endhighlight %}

In this case, the key=value pair will be ignored when the field is accessed.

#### Keys Without Values

You can always specify keys without a value:

{% highlight bash %}
$ cobbler distro edit --name=foo --ksmeta="a b c"
$ cobbler distro report --name=foo | grep "Kickstart Meta"
Kickstart Metadata             : {'a': '~', 'c': '~', 'b': '~'}
{% endhighlight %}

<div class="alert alert-info alert-block"><b>Note:</b> While valid syntax, this could cause problems for some fields where Cobbler expects a value (for example, --template-files).</div>

#### Keys With Multiple Values

It is also possible to specify multiple values for the same key. In this situation, Cobbler will convert the value portion to an array:

{% highlight bash %}
$ cobbler distro edit --name=foo --in-place --ksmeta="a=b a=c a=d"
$ cobbler distro report --name=foo | grep "Kickstart Meta"
Kickstart Metadata             : {'a': ['b', 'c', 'd']}
{% endhighlight %}

<div class="alert alert-info alert-block"><b>Note:</b> You must specify --in-place for this to work. By default the behavior will result in a single value, with the last specified value being the winner.</div>

## Standard Primative Sub-commands

All primative objects support the following standard sub-commands:

### List

The list command simply prints out an alphabetically sorted list of all objects. 

**Example:**

{% highlight bash %}
$ cobbler distro list
   centos6.3-x86_64
   debian6.0.5-x86_64
   f17-x86_64
   f18-beta6-x86_64
   opensuse12.2-i386
   opensuse12.2-x86_64
   opensuse12.2-xen-i386
   opensuse12.2-xen-x86_64
   sl6.2-i386
   sl6.2-x86_64
   ubuntu-12.10-i386
   ubuntu-12.10-x86_64
{% endhighlight %}

The list command is actually available as a top-level command as well, in which case it will iterate through every object type and list everything currently stored in your Cobbler database.

### Report

The report command prints a formatted report of each objects configuration. The optional --name argument can be used to limit the output to a single object, otherwise a report will be printed out for every object (if you have a lot of objects in a given category, this can be somewhat slow).

As with the list command, the report command is also available as a top-level command, in which case it will print a report for every object that is stored in your Cobbler database.

### Remove

The remove command uses only the --name option.

<div class="alert alert-info alert-block"><b>Note:</b> Removing an object will also remove any child objects (profiles, sub-profiles and/or systems). Prior versions of Cobbler required an additional --recursive option to enable this behavior, but it has become the default in recent versions so use remove with caution.</div>

**Example:**

{% highlight bash %}
$ cobbler [object] remove --name=foo
{% endhighlight %}

### Copy/Rename

The copy and rename commands work similarly, with both requiring a --name and --newname options.

**Example:**

{% highlight bash %}
$ cobbler [object] copy --name=foo --newname=bar
# or
$ cobbler [object] rename --name=foo --newname=bar
{% endhighlight %}

### Find

The find command allows you to search for objects based on object attributes.

Please refer to the {% linkup title:"Command Line Search" extrameta:2.4.0 %} section for more details regarding the find sub-command.

### Dumpvars (Debugging)

The dumpvars command is intended to be used for debugging purposes, and for those writing snippets. In general, it is not required for day-to-day use.

