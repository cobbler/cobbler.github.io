---
layout: manpage
title: Profiles & Sub-Profiles
meta: 2.4.0
---
A profile associates a distribution to additional specialized options, such as a kickstart automation file. Profiles are the core unit of provisioning and at least one profile must exist for every distribution to be provisioned. A profile might represent, for instance, a web server or desktop configuration. In this way, profiles define a role to be performed.

The profile command has the following sub-commands:

{% highlight bash %}
$ cobbler profile --help
usage
=====
cobbler profile add
cobbler profile copy
cobbler profile dumpvars
cobbler profile edit
cobbler profile find
cobbler profile getks
cobbler profile list
cobbler profile remove
cobbler profile rename
cobbler profile report
{% endhighlight %}

### Add/Edit Options

**Example:**

{% highlight bash %}
$ cobbler profile add --name=string --distro=string [options]
{% endhighlight %}

#### --name (required)
A descriptive name. This could be something like "rhel5webservers" or "f9desktops".

#### --distro (required)
The name of a previously defined cobbler distribution. This value is required.

#### --boot-files
This option is used to specify additional files that should be copied to the TFTP directory for the distro so that they can be fetched during earlier stages of the installation. Some distributions (for example, VMware ESXi) require this option to function correctly.

#### --clobber
This option allows "add" to overwrite an existing profile with the same name, so use it with caution.

#### --comment
An optional comment to associate with this profile.

#### --dhcp-tag
DHCP tags are used in the dhcp.template when using multiple networks.

Please refer to the {% linkup title:"Managing DHCP" extrameta:2.4.0 %} section for more details.

#### --enable-gpxe
When enabled, the system will use gPXE instead of regular PXE for booting.

Please refer to the {% linkup title:"Using gPXE" extrameta:2.4.0 %} section for details on using gPXE for booting over a network.

#### --enable-menu
When managing TFTP, Cobbler writes the `${tftproot}/pxelinux.cfg/default` file, which contains entries for all profiles. When this option is enabled for a given profile, it will not be added to the default menu.

#### --fetchable-files
This option is used to specify a list of key=value files that can be fetched via the python based TFTP server. The "value" portion of the name is the path/name they will be available as via TFTP.

Please see the {% linkup title:"Managing TFTP" extrameta:2.4.0 %} section for more details on using the python-based TFTP server.

#### --in-place
By default, any modifications to key=value fields (ksmeta, kopts, etc.) do no preserve the contents. To preserve the contents of these fields, --in-place should be specified. This option is also required is using a key with multiple values (for example, "foo=bar foo=baz").

#### --kickstart
Local filesystem path to a kickstart file. http:// URLs (even CGI’s) are also accepted, but a local file path is recommended, so that the kickstart templating engine can be taken advantage of.

If this parameter is not provided, the kickstart file will default to `/var/lib/cobbler/kickstarts/default.ks`. This file is initially blank, meaning default kickstarts are not automated "out of the box". Admins can change the default.ks if they desire.

When using kickstart files, they can be placed anywhere on the filesystem, but the recommended path is `/var/lib/cobbler/kickstarts`. If using the webapp to create new kickstarts, this is where the web application will put them.

#### --kopts
Sets kernel command-line arguments that the profile, and sub-profiles/systems dependant on it, will use during installation only. This field is a hash field, and accepts a set of key=value pairs:

**Example:**

{% highlight bash %}
--kopts="console=tty0 console=ttyS0,8,n,1 noapic"
{% endhighlight %}

#### --kopts-post
This is just like --kopts, though it governs kernel options on the installed OS, as opposed to kernel options fed to the installer. This requires some special snippets to be found in your kickstart template to work correctly.

#### --ksmeta
This is an advanced feature that sets variables available for use in templates. This field is a hash field, and accepts a set of key=value pairs:

**Example:**

{% highlight bash %}
--ksmeta="foo=bar baz=3 asdf"
{% endhighlight %}

See the section on {% linkup title:"Kickstart Templating" extrameta:2.4.0 %} for further information.

#### --mgmt-classes and --mgmt-parameters
Management classes and parameters that should be associated with this profile for use with configuration management systems.

Please see the {% linkup title:"Configuration Management" extrameta:2.4.0 %} section for more details on integrating Cobbler with configuration management systems.

#### --name-servers
If your nameservers are not provided by DHCP, you can specify a space seperated list of addresses here to configure each of the installed nodes to use them (provided the kickstarts used are installed on a per-system basis). Users with DHCP setups should not need to use this option. This is available to set in profiles to avoid having to set it repeatedly for each system record.

#### --name-servers-search
As with the --name-servers option, this can be used to specify the default domain search line. Users with DHCP setups should not need to use this option. This is available to set in profiles to avoid having to set it repeatedly for each system record.

#### --owners
The value for --owners is a space seperated list of users and groups as specified in `/etc/cobbler/users.conf`.

Users with small sites and a limited number of admins can probably ignore this option, since it only applies to the Cobbler WebUI and XMLRPC interface, not the "cobbler" command line tool run from the shell. Furthermore, this is only respected when using the "authz_ownership" module which must be enabled and is not the default.

Please see the {% linkup title:"Web Authorization" extrameta:2.4.0 %} section for more details.

#### --parent
This is an advanced feature.
           
Profiles may inherit from other profiles in lieu of specifing --distro. Inherited profiles will override any settings specified in their parent, with the exception of --ksmeta (templating) and --kopts (kernel options), which will be blended together.

**Example:**

If profile A has --kopts="x=7 y=2", B inherits from A, and B has --kopts="x=9 z=2", the actual kernel options that will be used for B are "x=9 y=2 z=2".

**Example:**

If profile B has --virt-ram=256 and A has --virt-ram of 512, profile B will use the value 256.

**Example:**

If profile A has a --virt-file-size of 5 and B does not specify a size, B will use the value from A.

#### --proxy
Specifies a proxy to use during the installation stage.

<div class="alert alert-info alert-block"><b>Note:</b> Not all distributions support using a proxy in this manner.</div>

#### --redhat-management-key
If you’re using Red Hat Network, Red Hat Satellite Server, or Spacewalk, you can store your authentication keys here and Cobbler can add the neccessary authentication code to your kickstart where the snippet named "redhat_register" is included. The default option specified in {% linkup title:"Cobbler Settings" extrameta:2.4.0 %} will be used if this field is left blank.

Please see the {% linkup title:"Tips For RHN" extrameta:2.4.0 %} section for more details on integrating Cobbler with RHN/Spacewalk.

#### --redhat-management-server
The RHN Satellite or Spacewalk server to use for registration. As above, the default option specified in {% linkup title:"Cobbler Settings" extrameta:2.4.0 %} will be used if this field is left blank.

Please see the {% linkup title:"Tips For RHN" extrameta:2.4.0 %} section for more details on integrating Cobbler with RHN/Spacewalk.

#### --repos
This is a space delimited list of all the repos (created with "cobbler repo add" and updated with "cobbler reposync") that this profile can make use of during kickstart installation. For example, an example might be --repos="fc6i386updates fc6i386extras" if the profile wants to access these two mirrors that are already mirrored on the cobbler server. Repo management is described in greater depth later in the manpage.

#### --server
This parameter should be useful only in select circumstances. If machines are on a subnet that cannot access the cobbler server using the name/IP as configured in the cobbler settings file, use this parameter to override that server name. See also --dhcp-tag for configuring the next server and DHCP informmation of the system if you are also using Cobbler to help manage your DHCP configuration.

#### --template-files
This feature allows cobbler to be used as a configuration management system. The argument is a space delimited string of key=value pairs. Each key is the path to a template file, each value is the path to install the file on the system. Koan also can retrieve these files from a cobbler server on demand, effectively allowing cobbler to function as a lightweight templated configuration management system.

Please see the {% linkup title:"Built-In Configuration Management" extrameta:2.4.0 %} section for more details on using template files.

#### --template-remote-kickstarts
If enabled, any kickstart with a remote path (http://, ftp://, etc.) will not be passed through Cobbler's template engine.

#### --virt-auto-boot
**(Virt-only)** When set, the VM will be configured to automatically start when the host reboots.

#### --virt-bridge
**(Virt-only)** This specifies the default bridge to use for all systems defined under this profile. If not specified, it will assume the default value in the cobbler settings file, which as shipped in the RPM is ’xenbr0’. If using KVM, this is most likely not correct. You may want to override this setting in the system object. Bridge settings are important as they define how outside networking will reach the guest. For more information on bridge setup, see the Cobbler Wiki, where there is a section describing koan usage.

#### --virt-cpus
**(Virt-only)** How many virtual CPUs should koan give the virtual machine?  The default for this value is set in the {% linkup title:"Cobbler Settings" extrameta:2.4.0 %} file, and should be set as an integer.

#### --virt-disk-driver
**(Virt-only)** The type of disk driver to use for the disk image, for example "raw" or "qcow2".

#### --virt-file-size
**(Virt-only)** How large the disk image should be in Gigabytes. The default for this value is set in the {% linkup title:"Cobbler Settings" extrameta:2.4.0 %} file. This can be a space seperated list (ex: "5,6,7") to allow for multiple disks of different sizes depending on what is given to --virt-path. This should be input as a integer or decimal value without units.
           
#### --virt-path
**(Virt-only)** Where to store the virtual image on the host system. Except for advanced cases, this parameter can usually be omitted. For disk images, the value is usually an absolute path to an existing directory with an optional file name component. There is support for specifying partitions "/dev/sda4" or volume groups "VolGroup00", etc.

For multiple disks, seperate the values with commas such as "VolGroup00,VolGroup00" or "/dev/sda4,/dev/sda5". Both those examples would create two disks for the VM.
           
#### --virt-ram
**(Virt-only)** How many megabytes of RAM to consume. The default for this value is set in the {% linkup title:"Cobbler Settings" extrameta:2.4.0 %} file. This should be input as an integer without units, and will be interpretted as MB.

#### --virt-type
**(Virt-only)** Koan can install images using several different virutalization types. Choose one or the other strings to specify, or values will default to attempting to find a compatible installation type on the client system ("auto"). See the {% linkup title:"Koan" extrameta:2.4.0 %} section for more documentation. The default for this value is set in the {% linkup title:"Cobbler Settings" extrameta:2.4.0 %} file.

### Get Kickstart (getks)

The getks command shows the rendered kickstart/response file (preseed, etc.) for the given profile. This is useful for previewing what will be downloaded from Cobbler when the system is building. This is also a good opportunity to catch snippets that are not rendering correctly.

As with remove, the --name option is required and is the only valid argument.

**Example:**

{% highlight bash %}
$ cobbler profile getks --name=foo | less
{% endhighlight %}
