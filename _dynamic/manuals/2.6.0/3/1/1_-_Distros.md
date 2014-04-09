---
layout: manpage
title: Distros
meta: 2.6.0
---
The first step towards installing systems with Cobbler is to add a distribution record to cobbler’s configuration.

The distro command has the following sub-commands:

{% highlight bash %}
$ cobbler distro --help
usage
=====
cobbler distro add
cobbler distro copy
cobbler distro edit
cobbler distro find
cobbler distro list
cobbler distro remove
cobbler distro rename
cobbler distro report
{% endhighlight %}

### Add/Edit Options

In general, it’s really a lot easier to follow the import workflow -- it only requires waiting for the mirror content to be copied and/or scanned. Imported mirrors also save time during install since they don’t have to hit external installation sources. Please read the {% linkup title:"Cobbler Import" extrameta:2.6.0 %} documentation for more details.

If you want to be explicit with distribution definition, however, here’s how it works:

<b>Example:</b>

{% highlight bash %}
$ cobbler distro add --name=string --kernel=path --initrd=path [options]
{% endhighlight %}       

<table class="table table-condensed table-striped">
<thead>
 <tr>
  <th>Field Name</th>
  <th>Description</th>
 </tr>
</thead>
<tbody>
 <tr>
  <td class="nowrap">--name (required)</td>
  <td>A string identifying the distribution, this should be something like "rhel4".</td>
 </tr>
 <tr>
  <td class="nowrap">--kernel (required)</td>
  <td>An absolute filesystem path to a kernel image.</td>
 </tr>
 <tr>
  <td class="nowrap">--initrd (required)</td>
  <td>An absolute filesystem path to a initrd image.</td>
 </tr>
 <tr>
  <td class="nowrap">--arch</td>
  <td>
   <p>Sets the architecture for the PXE bootloader and also controls how koan’s --replace-self option will operate.</p>
   <p>The default setting (’standard’) will use pxelinux. Set to ’ia64’ to use elilo. ’ppc’ and ’ppc64’ use yaboot. ’s390x’ is not PXEable, but koan supports it for reinstalls.</p>
   <p>’x86’ and ’x86_64’ effectively do the same thing as standard.</p>
   <p>If you perform a cobbler import, the arch field will be auto-assigned.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--boot-files</td>
  <td>
   <p>This option is used to specify additional files that should be copied to the TFTP directory for the distro so that they can be fetched during earlier stages of the installation. Some distributions (for example, VMware ESXi) require this option to function correctly.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--breed</td>
  <td>
   <p>Controls how various physical and virtual parameters, including kernel arguments for automatic installation, are to be treated. Defaults to "redhat", which is a suitable value for Fedora and CentOS as well. It means anything redhat based.</p>
   <p>There is limited experimental support for specifying "debian", "ubuntu", or "suse", which treats the kickstart file as a different format and changes the kernel arguments appropriately. Support for other types of distributions is possible in the future. See the Wiki for the latest information about support for these distributions.</p>
   <p>The file used for the answer file, regardless of the breed setting, is the value used for --kickstart when creating the profile. In other words, if another distro calls their answer file something other than a "kickstart", the kickstart parameter still governs where that answer file is.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--clobber</td>
  <td>This option allows "add" to overwrite an existing distro with the same name, so use it with caution.</td>
 </tr>
 <tr>
  <td class="nowrap">--comment</td>
  <td>An optional comment to associate with this distro.</td>
 </tr>
 <tr>
  <td class="nowrap">--fetchable-files</td>
  <td>
   <p>This option is used to specify a list of key=value files that can be fetched via the python based TFTP server. The "value" portion of the name is the path/name they will be available as via TFTP.</p>
   <p>Please see the {% linkup title:"Managing TFTP" extrameta:2.6.0 %} section for more details on using the python-based TFTP server.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--in-place</td>
  <td>
   <p>By default, any modifications to key=value fields (ksmeta, kopts, etc.) do no preserve the contents.</p>
   <p><b>Example:</b></p>
{% highlight bash %}
$ cobbler distro edit --name=foo --ksmeta="a=b c=d"
$ cobbler distro report --name=foo | grep "Kickstart Meta"
Kickstart Metadata             : {'a': 'b', 'c': 'd'}
$ cobbler distro edit --name=foo --ksmeta="e=f"
$ cobbler distro report --name=foo | grep "Kickstart Meta"
Kickstart Metadata             : {'e': 'f'}
{% endhighlight %}
   <p>To preserve the contents of these fields, --in-place should be specified:</P>
{% highlight bash %}
$ cobbler distro edit --name=foo --ksmeta="a=b c=d"
$ cobbler distro report --name=foo | grep "Kickstart Meta"
Kickstart Metadata             : {'a': 'b', 'c': 'd'}
$ cobbler distro edit --name=foo --in-place --ksmeta="e=f"
$ cobbler distro report --name=foo | grep "Kickstart Meta"
Kickstart Metadata             : {'a': 'b', 'c': 'd', 'e': 'f'}
{% endhighlight %}
  </td>
 </tr>
 <tr>
  <td class="nowrap">--kopts</td>
  <td>
   <p>Sets kernel command-line arguments that the distro, and profiles/systems dependant on it, will use during installation only. This field is a hash field, and accepts a set of key=value pairs:</p>
   <p><b>Example:</b></p>
{% highlight bash %}
--kopts="console=tty0 console=ttyS0,8,n,1 noapic"
{% endhighlight %}
  </td>
 </tr>
 <tr>
  <td class="nowrap">--kopts-post</td>
  <td>This is just like --kopts, though it governs kernel options on the installed OS, as opposed to kernel options fed to the installer. This requires some special snippets to be found in your kickstart template to work correctly.</td>
 </tr>
 <tr>
  <td class="nowrap">--ksmeta</td>
  <td>
   <p>This is an advanced feature that sets variables available for use in templates. This field is a hash field, and accepts a set of key=value pairs:</p>
   <p><b>Example:</b></p>
{% highlight bash %}
--ksmeta="foo=bar baz=3 asdf"
{% endhighlight %}
   <p>See the section on {% linkup title:"Kickstart Templating" extrameta:2.6.0 %} for further information.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--mgmt-classes</td>
  <td>
   <p>Management classes that should be associated with this distro for use with configuration management systems.</p>
   <p>Please see the {% linkup title:"Configuration Management" extrameta:2.6.0 %} section for more details on integrating Cobbler with configuration management systems.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--os-version</td>
  <td>Generally this field can be ignored. It is intended to alter some hardware setup for virtualized instances when provisioning guests with koan. The valid options for --os-version vary depending on what is specified for --breed. If you specify an invalid option, the error message will contain a list of valid os versions that can be used. If you do not know the os version or it does not appear in the list, omitting this argument or using "other" should be perfectly fine. Largely this is needed to support older distributions in virtualized settings, such as "rhel2.1", one of the OS choices if the breed is set to "redhat". If you do not encounter any problems with virtualized instances, this option can be safely ignored.</td>
 </tr>
 <tr>
  <td class="nowrap">--owners</td>
  <td>
   <p>The value for --owners is a space seperated list of users and groups as specified in <code>/etc/cobbler/users.conf</code>.</p>
   <p>Users with small sites and a limited number of admins can probably ignore this option, since it only applies to the Cobbler WebUI and XMLRPC interface, not the "cobbler" command line tool run from the shell. Furthermore, this is only respected when using the "authz_ownership" module which must be enabled and is not the default.</p>
   <p>Please see the {% linkup title:"Web Authorization" extrameta:2.6.0 %} section for more details.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--redhat-management-key</td>
  <td>
   <p>If you’re using Red Hat Network, Red Hat Satellite Server, or Spacewalk, you can store your authentication keys here and Cobbler can add the neccessary authentication code to your kickstart where the snippet named "redhat_register" is included. The default option specified in {% linkup title:"Cobbler Settings" extrameta:2.6.0 %} will be used if this field is left blank.</p>
   <p>Please see the {% linkup title:"Tips For RHN" extrameta:2.6.0 %} section for more details on integrating Cobbler with RHN/Spacewalk.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--redhat-management-server</td>
  <td>
   <p>The RHN Satellite or Spacewalk server to use for registration. As above, the default option specified in {% linkup title:"Cobbler Settings" extrameta:2.6.0 %} will be used if this field is left blank.</p>
   <p>Please see the {% linkup title:"Tips For RHN" extrameta:2.6.0 %} section for more details on integrating Cobbler with RHN/Spacewalk.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--template-files</td>
  <td>
   <p>This feature allows cobbler to be used as a configuration management system. The argument is a space delimited string of key=value pairs. Each key is the path to a template file, each value is the path to install the file on the system. Koan also can retrieve these files from a cobbler server on demand, effectively allowing cobbler to function as a lightweight templated configuration management system.</p>
   <p>Please see the {% linkup title:"Built-In Configuration Management" extrameta:2.6.0 %} section for more details on using template files.</p>
  </td>
 </tr>
</tbody>
</table>
