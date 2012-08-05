---
layout: manpage
title: Distros
meta: 2.2.3
---
The first step towards installing systems with Cobbler is to add a distribution record to cobbler’s configuration.

If there is an rsync mirror, DVD, NFS, or filesystem tree available that you would rather import instead, skip down to the documentation about the "import" command.  It’s really a lot easier to follow the import workflow -- it only requires waiting for the mirror content to be copied and/or scanned.  Imported mirrors also save time during install since they don’t have to hit external install sources. 

If you want to be explicit with distribution definition, however, here’s how it works:

#### Example:
{% highlight bash %}
$ cobbler distro add --name=string --kernel=path --initrd=path [--kopts=string] [--kopts-post=string] \
[--ksmeta=string] [--arch=x86|x86_64|ia64] [--breed=redhat|debian|suse] [--template-files=string]
{% endhighlight %}       

### name
a string identifying the distribution, this should be something like "rhel4".

### kernel
An absolute filesystem path to a kernel image

### initrd
An absolute filesystem path to a initrd image

### kopts
Sets kernel command-line arguments that the distro, and profiles/systems dependant on it, will use.  To remove a kernel argument that may be added by a higher cobbler object (or in the global settings), you can prefix it with a "!".

#### Example:
{% highlight bash %}
--kopts="foo=bar baz=3 asdf !gulp"
{% endhighlight %}

This example passes the arguments "foo=bar baz=3 asdf" but will make sure "gulp" is not passed even if it was requested at a level higher up in the cobbler configuration.

### kopts-post
This is just like --kopts, though it governs kernel options on the installed OS, as opposed to kernel options fed to the installer.  The syntax is exactly the same.  This requires some special snippets to be found in your kickstart template in order for this to work.  Kickstart templating is described later on in this document.

#### Example:
{% highlight bash %}
--kops-post="noapic"
{% endhighlight %}

### arch
Sets the architecture for the PXE bootloader and also controls how koan’s --replace-self option will operate.
           
The default setting (’standard’) will use pxelinux.   Set to ’ia64’ to use elilo.  ’ppc’ and ’ppc64’ use yaboot.  ’s390x’ is not PXEable, but koan supports it for reinstalls.

’x86’ and ’x86_64’ effectively do the same thing as standard.

If you perform a cobbler import, the arch field will be auto-assigned.

### ksmeta
This is an advanced feature that sets kickstart variables to substitute, thus enabling kickstart files to be treated as templates.  Templates are powered using Cheetah and are described further along in this manpage as well as on the Cobbler Wiki.

#### Example:
{% highlight bash %}
--ksmeta="foo=bar baz=3 asdf"
{% endhighlight %}

See the section on {% linkup title:"Kickstart Templating" extrameta:2.2.3 %} for further information.

### breed
Controls how various physical and virtual parameters, including kernel arguments for automatic installation, are to be treated.  Defaults to "redhat", which is a suitable value for Fedora and CentOS as well.  It means anything redhat based.

There is limited experimental support for specifying "debian", "ubuntu", or "suse", which treats the kickstart file as a different format and changes the kernel arguments appropriately.   Support for other types of distributions is possible in the future.  See the Wiki for the latest information about support for these distributions.

The file used for the answer file, regardless of the breed setting, is the value used for --kickstart when creating the profile.  In other words, if another distro calls their answer file something other than a "kickstart", the kickstart parameter still governs where that answer file is.

### os-version
Generally this field can be ignored.   It is intended to alter some hardware setup for virtualized instances when provisioning guests with koan.  The valid options for --os-version vary depending on what is specified for --breed.  If you specify an invalid option, the error message will contain a list of valid os versions that can be used.  If you do not know the os version or it does not appear in the list, omitting this argument or using "other" should be perfectly fine.  Largely this is needed to support older distributions in virtualized settings, such as "rhel2.1", one of the OS choices if the breed is set to "redhat".  If you do not encounter any problems with virtualized instances, this option can be safely ignored.

### owners
Users with small sites and a limited number of admins can probably ignore this option.  All cobbler objects (distros, profiles, systems, and repos) can take a --owners parameter to specify what cobbler users can edit particular objects.  This only applies to the Cobbler WebUI and XMLRPC interface, not the "cobbler" command line tool run from the shell.  Furthermore, this is only respected by the "authz_ownership" module which must be enabled in /etc/cobbler/modules.conf.  The value for --owners is a space seperated list of users and groups as specified in /etc/cobbler/users.conf.  For more information see the users.conf file as well as the Cobbler Wiki.  In the default Cobbler configuration, this value is completely ignored, as is users.conf.

### template-files
This feature allows cobbler to be used as a configuration management system.  The argument is a space delimited string of key=value pairs. Each key is the path to a template file, each value is the path to install the file on the system.  This is described in further detail on the Cobbler Wiki and is implemented using special code in the post install.  Koan also can retrieve these files from a cobbler server on demand, effectively allowing cobbler to function as a lightweight templated configuration management system.

### redhat-management-key
If you’re using Red Hat Network, Red Hat Satellite Server, or Spacewalk, you can store your authentication keys here and Cobbler can add the neccessary authentication code to your kickstart where the snippet named "redhat_register" is included.  Read more about setup in /etc/cobbler/settings.