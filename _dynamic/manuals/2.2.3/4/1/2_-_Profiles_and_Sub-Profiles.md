---
layout: manpage
title: Profiles & Sub-Profiles
meta: 2.2.3
---
A profile associates a distribution to additional specialized options, such as a kickstart automation file.  Profiles are the core unit of provisioning and at least one profile must exist for every distribution to be provisioned.  A profile might represent, for instance, a web server or desktop configuration.  In this way, profiles define a role to be performed.


#### Example:
{% highlight bash %}
$ cobbler profile add --name=string --distro=string [--kickstart=path] [--kopts=string] [--ksmeta=string] \
[--virt-file-size=gigabytes] [--virt-ram=megabytes] [--virt-type=string] [--virt-cpus=integer] \
[--virt-path=string] [--virt-bridge=string] [--server-override] [--parent=profile]
{% endhighlight %}

Arguments are the same as listed for distributions, save for the removal of "arch" and "breed", and with the additions listed below:

### name
A descriptive name.  This could be something like "rhel5webservers" or "f9desktops".

### distro
The name of a previously defined cobbler distribution. This value is required.

### kickstart
Local filesystem path to a kickstart file.  http:// URLs (even CGI’s) are also accepted, but a local file path is recommended, so that the kickstart templating engine can be taken advantage of.

If this parameter is not provided, the kickstart file will default to /var/lib/cobbler/kickstarts/default.ks.  This file is initially blank, meaning default kickstarts are not automated "out of the box".  Admins can change the default.ks if they desire.

When using kickstart files, they can be placed anywhere on the filesystem, but the recommended path is /var/lib/cobbler/kickstarts.   If using the webapp to create new kickstarts, this is where the web application will put them.

### nameservers
If your nameservers are not provided by DHCP, you can specify a space seperated list of addresses here to configure each of the installed nodes to use them (provided the kickstarts used are installed on a per-system basis).   Users with DHCP setups should not need to use this option.  This is available to set in profiles to avoid having to set it repeatedly for each system record.

### virt-file-size
**(Virt-only)** How large the disk image should be in Gigabytes.  The default is "5".  This can be a space seperated list (ex: "5,6,7") to allow for multiple disks of different sizes depending on what is given to --virt-path.  This should be input as a integer or decimal value without units.
           
### virt-ram
**(Virt-only)** How many megabytes of RAM to consume.  The default is 512 MB.  This should be input as an integer without units.

### virt-type
**(Virt-only)** Koan can install images using either Xen paravirt ("xenpv") or QEMU/KVM ("qemu").  Choose one or the other strings to specify, or values will default to attempting to find a compatible installation type on the client system ("auto").  See the "koan" manpage for more documentation.  The default virt-type can be configured in the cobbler settings file such that this parameter does not have to be provided.  Other virtualization types are supported, for information on those options (such as VMware), see the Cobbler Wiki.

### virt-cpus
**(Virt-only)** How many virtual CPUs should koan give the virtual machine?  The default is 1.  This is an integer.

### virt-path
**(Virt-only)** Where to store the virtual image on the host system. Except for advanced cases, this parameter can usually be omitted. For disk images, the value is usually an absolute path to an existing directory with an optional file name component.  There is support for specifying partitions "/dev/sda4" or volume groups "VolGroup00", etc.
           
For multiple disks, seperate the values with commas such as "VolGroup00,VolGroup00" or "/dev/sda4,/dev/sda5".  Both those examples would create two disks for the VM.

### virt-bridge
**(Virt-only)** This specifies the default bridge to use for all systems defined under this profile.  If not specified, it will assume the default value in the cobbler settings file, which as shipped in the RPM is ’xenbr0’.  If using KVM, this is most likely not correct.  You may want to override this setting in the system object.  Bridge settings are important as they define how outside networking will reach the guest.  For more information on bridge setup, see the Cobbler Wiki, where there is a section describing koan usage.

### repos
This is a space delimited list of all the repos (created with "cobbler repo add" and updated with "cobbler reposync") that this profile can make use of during kickstart installation.  For example, an example might be --repos="fc6i386updates fc6i386extras" if the profile wants to access these two mirrors that are already mirrored on the cobbler server.  Repo management is described in greater depth later in the manpage.

### parent
This is an advanced feature.
           
Profiles may inherit from other profiles in lieu of specifing --distro.  Inherited profiles will override any settings specified in their parent, with the exception of --ksmeta (templating) and --kopts (kernel options), which will be blended together.

#### Example:
If profile A has --kopts="x=7 y=2", B inherits from A, and B has --kopts="x=9 z=2", the actual kernel options that will be used for B are "x=9 y=2 z=2".

#### Example:
If profile B has --virt-ram=256 and A has --virt-ram of 512, profile B will use the value 256.

#### Example:
If profile A has a --virt-file-size of 5 and B does not specify a size, B will use the value from A.

### server-override
This parameter should be useful only in select circumstances.  If machines are on a subnet that cannot access the cobbler server using the name/IP as configured in the cobbler settings file, use this parameter to override that server name.   See also --dhcp-tag for configuring the next server and DHCP informmation of the system if you are also using Cobbler to help manage your DHCP configuration.