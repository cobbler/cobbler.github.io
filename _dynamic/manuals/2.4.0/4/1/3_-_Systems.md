---
layout: manpage
title: Systems
meta: 2.4.0
---
System records map a piece of hardware (or a virtual machine) with the cobbler profile to be assigned to run on it. This may be thought of as chosing a role for a specific system.

The system commmand has the following sub-commands:

{% highlight bash %}
$ cobbler system --help
usage
=====
cobbler system add
cobbler system copy
cobbler system dumpvars
cobbler system edit
cobbler system find
cobbler system getks
cobbler system list
cobbler system poweroff
cobbler system poweron
cobbler system powerstatus
cobbler system reboot
cobbler system remove
cobbler system rename
cobbler system report
{% endhighlight %}

Note that if provisioning via koan and PXE menus alone, it is not required to create system records in cobbler, though they are useful when system specific customizations are required. One such customization would be defining the MAC address. If there is a specific role inteded for a given machine, system records should be created for it.

System commands have a wider variety of control offered over network details. In order to use these to the fullest possible extent, the kickstart template used by cobbler must contain certain kickstart snippets (sections of code specifically written for Cobbler to make these values become reality). Compare your kickstart templates with the stock ones in /var/lib/cobbler/kickstarts if you have upgraded, to make sure you can take advantage of all options to their fullest potential. If you are a new cobbler user, base your kickstarts off of these templates. Non-kickstart based distributions, while supported by Cobbler, may not be able to use all of these features.

**Example:**

{% highlight bash %}
$ cobbler system add --name=string [--profile=name|--image=name] [options]
{% endhighlight %}

As you can see, a system must either be assigned to a --profile or an --image, which are mutually exclusive options.

### Add/Edit Options

#### --name (required)
The system name works like the name option for other commands.

If the name looks like a MAC address or an IP, the name will implicitly be used for either --mac or --ip-address of the first interface, respectively. However, it’s usually better to give a descriptive name -- don’t rely on this behavior.

A system created with name "default" has special semantics. If a default system object exists, it sets all undefined systems to PXE to a specific profile. Without a "default" system name created, PXE will fall through to local boot for unconfigured systems.

When using "default" name, don’t specify any other arguments than --profile ... they won’t be used.

#### --profile (required, if --image not set)
The name of the profile or sub-profile to which this system belongs. 

#### --image (required, if --profile not set)
The name of the image to which this system belongs.

#### --boot-files
This option is used to specify additional files that should be copied to the TFTP directory for the distro so that they can be fetched during earlier stages of the installation. Some distributions (for example, VMware ESXi) require this option to function correctly.

#### --clobber
This option allows "add" to overwrite an existing system with the same name, so use it with caution.

#### --comment
An optional comment to associate with this system.

#### --enable-gpxe
When enabled, the system will use gPXE instead of regular PXE for booting.

Please refer to the {% linkup title:"Using gPXE" extrameta:2.4.0 %} section for details on using gPXE for booting over a network.

#### --fetchable-files
This option is used to specify a list of key=value files that can be fetched via the python based TFTP server. The "value" portion of the name is the path/name they will be available as via TFTP.

Please see the {% linkup title:"Managing TFTP" extrameta:2.4.0 %} section for more details on using the python-based TFTP server.

#### --gateway
Sets the default gateway, which in Redhat-based systems is typically in /etc/sysconfig/network. Per-interface gateways are not supported at this time. This option will be ignored unless --static=1 is also set on the interface.

#### --hostname
This field corresponds to the hostname set in a systems /etc/sysconfig/network file. This has no bearing on DNS, even when manage_dns is enabled. Use --dns-name instead for that feature, which is a per-interface setting.

#### --in-place
By default, any modifications to key=value fields (ksmeta, kopts, etc.) do no preserve the contents. To preserve the contents of these fields, --in-place should be specified. This option is also required is using a key with multiple values (for example, "foo=bar foo=baz").

#### --kickstart
While it is recommended that the --kickstart parameter is only used within for the "profile add" command, there are limited scenarios when an install base switching to cobbler may have legacy kickstarts created on a per-system basis (one kickstart for each system, nothing shared) and may not want to immediately make use of the cobbler templating system. This allows specifing a kickstart for use on a per-system basis. Creation of a parent profile is still required. If the kickstart is a filesystem location, it will still be treated as a cobbler template.

#### --kopts
Sets kernel command-line arguments that the system will use during installation only. This field is a hash field, and accepts a set of key=value pairs:

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

#### --ldap-enabled, --ldap-type
Cobbler contains features that enable ldap management for easier configuration after system provisioning. If set true, koan will run the ldap command as defined by the systems ldap_type. The default value is false.

#### --mgmt-classes and --mgmt-parameters
Management classes and parameters that should be associated with this system for use with configuration management systems.

Please see the {% linkup title:"Configuration Management" extrameta:2.4.0 %} section for more details on integrating Cobbler with configuration management systems.

#### --monit-enabled
If set true, koan will reload monit after each configuration run. The default value is false.

#### --name-servers
If your nameservers are not provided by DHCP, you can specify a space seperated list of addresses here to configure each of the installed nodes to use them (provided the kickstarts used are installed on a per-system basis). Users with DHCP setups should not need to use this option. This is available to set in profiles to avoid having to set it repeatedly for each system record.

#### --name-servers-search
As with the --name-servers option, this can be used to specify the default domain search line. Users with DHCP setups should not need to use this option. This is available to set in profiles to avoid having to set it repeatedly for each system record.

#### --netboot-enabled
If set false, the system will be provisionable through koan but not through standard PXE. This will allow the system to fall back to default PXE boot behavior without deleting the cobbler system object. The default value allows PXE. Cobbler contains a PXE boot loop prevention feature (pxe_just_once, can be enabled in /etc/cobbler/settings) that can automatically trip off this value after a system gets done installing. This can prevent installs from appearing in an endless loop when the system is set to PXE first in the BIOS order.

#### --owners
The value for --owners is a space seperated list of users and groups as specified in /etc/cobbler/users.conf.

#### --power-address, --power-type, --power-user, --power-password, --power-id
Cobbler contains features that enable integration with power management for easier installation, reinstallation, and management of machines in a datacenter environment. These parameters are described in the {% linkup title:"Power Management" extrameta:2.4.0 %} section under {% linkup title:"Advanced Topics" extrameta:2.4.0 %}. If you have a power-managed datacenter/lab setup, usage of these features may be something you are interested in.

#### --proxy
Specifies a proxy to use during the installation stage.

<div class="alert alert-info alert-block"><b>Note:</b> Not all distributions support using a proxy in this manner.</div>

#### --redhat-management-key
If you’re using Red Hat Network, Red Hat Satellite Server, or Spacewalk, you can store your authentication keys here and Cobbler can add the neccessary authentication code to your kickstart where the snippet named "redhat_register" is included. The default option specified in {% linkup title:"Cobbler Settings" extrameta:2.4.0 %} will be used if this field is left blank.

Please see the {% linkup title:"Tips For RHN" extrameta:2.4.0 %} section for more details on integrating Cobbler with RHN/Spacewalk.

#### --redhat-management-server
The RHN Satellite or Spacewalk server to use for registration. As above, the default option specified in {% linkup title:"Cobbler Settings" extrameta:2.4.0 %} will be used if this field is left blank.

Please see the {% linkup title:"Tips For RHN" extrameta:2.4.0 %} section for more details on integrating Cobbler with RHN/Spacewalk.

#### --repos-enabled
If set true, koan can reconfigure repositories after installation.

#### --server
This parameter should be useful only in select circumstances. If machines are on a subnet that cannot access the cobbler server using the name/IP as configured in the cobbler settings file, use this parameter to override that server name. See also --dhcp-tag for configuring the next server and DHCP informmation of the system if you are also using Cobbler to help manage your DHCP configuration.

#### --status
An optional field used to keep track of a systems build or deployment status. This field is only set manually, and is not updated automatically at this time.

#### --template-files
This feature allows cobbler to be used as a configuration management system. The argument is a space delimited string of key=value pairs. Each key is the path to a template file, each value is the path to install the file on the system. Koan also can retrieve these files from a cobbler server on demand, effectively allowing cobbler to function as a lightweight templated configuration management system.

Please see the {% linkup title:"Built-In Configuration Management" extrameta:2.4.0 %} section for more details on using template files.

#### --template-remote-kickstarts
If enabled, any kickstart with a remote path (http://, ftp://, etc.) will not be passed through Cobbler's template engine.

#### --virt-auto-boot
**(Virt-only)** When set, the VM will be configured to automatically start when the host reboots.

#### --virt-cpus
**(Virt-only)** The number of virtual CPUs to allocate to a system. The default for this value is set in the {% linkup title:"Cobbler Settings" extrameta:2.4.0 %} file, and should be set as an integer.

#### --virt-disk-driver
**(Virt-only)** The type of disk driver to use for the disk image, for example "raw" or "qcow2".

#### --virt-file-size
**(Virt-only)** How large the disk image should be in Gigabytes. The default for this value is set in the {% linkup title:"Cobbler Settings" extrameta:2.4.0 %} file. This can be a space seperated list (ex: "5,6,7") to allow for multiple disks of different sizes depending on what is given to --virt-path. This should be input as a integer or decimal value without units.

#### --virt-path
**(Virt-only)** Where to store the virtual image on the host system. Except for advanced cases, this parameter can usually be omitted. For disk images, the value is usually an absolute path to an existing directory with an optional file name component. There is support for specifying partitions "/dev/sda4" or volume groups "VolGroup00", etc.

For multiple disks, seperate the values with commas such as "VolGroup00,VolGroup00" or "/dev/sda4,/dev/sda5". Both those examples would create two disks for the VM.

#### --virt-pxe-boot
**(Virt-only)** When set, the guest VM will use PXE to boot. By default, koan will use the --location option to virt-install to specify the installer for the guest.

#### --virt-ram
**(Virt-only)** How many megabytes of RAM to consume. The default for this value is set in the {% linkup title:"Cobbler Settings" extrameta:2.4.0 %} file. This should be input as an integer without units, and will be interpretted as MB.

#### --virt-type
**(Virt-only)** Koan can install images using several different virutalization types. Choose one or the other strings to specify, or values will default to attempting to find a compatible installation type on the client system ("auto"). See the {% linkup title:"Koan" extrameta:2.4.0 %} section for more documentation. The default for this value is set in the {% linkup title:"Cobbler Settings" extrameta:2.4.0 %} file.

### Interface Specific Commands

System primatives are unique in that they are the only object in Cobbler that embeds another complex object - interfaces. As such, there is an entire subset of options that are specific to interfaces only.

#### --interface

All interface options require the use of the --interface=ifname option. If this is omitted, Cobbler will default to using the interface name "eth0", which may not be what you want. We may also change this default behavior in the future, so in general it is always best to explicitly specify the interface name with this option.

<div class="alert alert-info alert-block"><b>Note:</b> **You can only edit one interface at a time!** If you specify multiple --interface options, only the last one will be used.</div>

**Interface naming notes:**

Additional interfaces can be specified (for example: eth1, or any name you like, as long as it does not conflict with any reserved names such as kernel module names) for use with the edit command. Defining VLANs this way is also supported, if you want to add VLAN 5 on interface eth0, simply name your interface eth0:5.

**Example:**

{% highlight bash %}
$ cobbler system edit --name=foo --ip-address=192.168.1.50 --mac=AA:BB:CC:DD:EE:A0
$ cobbler system edit --name=foo --interface=eth0 --ip-address=192.168.1.51 --mac=AA:BB:CC:DD:EE:A1
$ cobbler system report foo
{% endhighlight %}

Interfaces can be deleted using the --delete-interface option.

**Example:**

{% highlight bash %}
$ cobbler system edit --name=foo --interface=eth2 --delete-interface
{% endhighlight %}

#### --bonding-opts and --bridge-opts
Bonding and bridge options for the master-interface may be specified using --bonding-opts="foo=1 bar=2" or --bridge-opts="foo=1 bar=2", respectively. These are only used if the --interface-type is a master or bonded_bridge_slave (which is also a bond master).

#### --dhcp-tag
If you are setting up a PXE environment with multiple subnets/gateways, and are using cobbler to manage a DHCP configuration, you will probably want to use this option. If not, it can be ignored.

By default, the dhcp tag for all systems is "default" and means that in the DHCP template files the systems will expand out where $insert_cobbler_systems_definitions is found in the DHCP template. However, you may want certain systems to expand out in other places in the DHCP config file. Setting --dhcp-tag=subnet2 for instance, will cause that system to expand out where $insert_cobbler_system_definitions_subnet2 is found, allowing you to insert directives to specify different subnets (or other parameters) before the DHCP configuration entries for those particular systems.

#### --dns-name
If using the DNS management feature (see advanced section -- cobbler supports auto-setup of BIND and dnsmasq), use this to define a hostname for the system to receive from DNS.

**Example:**
{% highlight bash %}
--dns-name=mycomputer.example.com
{% endhighlight %}

This is a per-interface parameter. If you have multiple interfaces, it may be different for each interface, for example, assume a DMZ / dual-homed setup.

#### --interface-type and --interface-master
One of the other advanced networking features supported by Cobbler is NIC bonding and bridging. You can use this to bond multiple physical network interfaces to one single logical interface to reduce single points of failure in your network, or to create bridged interfaces for things like tunnels and virtual machine networks. Supported values for the --interface-type parameter are "bond", "bond_slave", "bridge", "bridge_slave" and "bonded_bridge_slave". If one of the "_slave" options is specified, you also need to define the master-interface for this bond using --interface-master=INTERFACE.

<div class="alert alert-info alert-block"><b>Note:</b> The options "master" and "slave" are deprecated, and are assumed to me "bond" and "bond_slave" when encountered. When a system object is saved, the deprecated values will be overwritten with the new, correct values.</div>

For more details on using these interface types, please see the {% linkup title:"Advanced Networking" extrameta:2.4.0 %} section.

#### --ip-address
If cobbler is configured to generate a DHCP configuratition (see advanced section), use this setting to define a specific IP for this system in DHCP. Leaving off this parameter will result in no DHCP management for this particular system.

**Example:**
{% highlight bash %}
--ip-address=192.168.1.50
{% endhighlight %}

Note for Itanium users:  this setting is always required for IA64 regardless of whether DHCP management is enabled.
           
If DHCP management is disabled and the interface is labelled --static=1, this setting will be used for static IP configuration.

Special feature: To control the default PXE behavior for an entire subnet, this field can also be passed in using CIDR notation. If --ip-address is CIDR, do not specify any other arguments other than --name and --profile.

When using the CIDR notation trick, don’t specify any arguments other than --name and --profile... they won’t be used.

#### --ipv6-address
The IPv6 address to use for this interface.

<div class="alert alert-info alert-block"><b>Note:</b> This is not mutually exclusive with the --ipv6-autoconfiguration option, as interfaces can have many IPv6 addresses.</div>

#### --ipv6-autoconfiguration
Use autoconfiguration mode to obtain the IPv6 address for this interface.

#### --ipv6-default-device
The default IPv6 device.

#### --ipv6-secondaries
The list of IPv6 secondaries for this interface.

#### --ipv6-mtu
Same as --mtu, however specific to the IPv6 stack for this interface.

#### --ipv6-static-routes
Same as --static-routes, however specific to the IPv6 stack for this interface.

#### --ipv6-default-gateway
This is the default gateway to use for this interface, specific only to the IPv6 stack. Unlike --gateway, this is set per-interface.

#### --mac-address (--mac)
Specifying a mac address via --mac allows the system object to boot directly to a specific profile via PXE, bypassing cobbler’s PXE menu. If the name of the cobbler system already looks like a mac address, this is inferred from the system name and does not need to be specified.

MAC addresses have the format AA:BB:CC:DD:EE:FF. It’s higly recommended to register your MAC-addresses in Cobbler if you’re using static adressing with multiple interfaces, or if you are using any of the advanced networking features like bonding, bridges or VLANs.

Cobbler does contain a feature (enabled in /etc/cobbler/settings) that can automatically add new system records when it finds profiles being provisioned on hardware it has seen before. This may help if you do not have a report of all the MAC addresses in your datacenter/lab configuration.

#### --mtu
Sets the MTU (max transfer unit) property for the interface. Normally, this is set to 9000 to enable jumbo frames, but remember you must also enable it on in your switch configuration to function properly.

#### --management
When set to true, this interface will take precedence over others as the communication link to the Cobbler server. This means it will be used as the default kickstart interface if there are multiple interfaces to choose from.

#### --static
Indicates that this interface is statically configured. Many fields (such as gateway/subnet) will not be used unless this field is enabled .When Cobbler is managing DHCP, this will result in a static lease entry being created in the dhcpd.conf.

#### --static-routes
This is a space delimited list of ip/mask:gateway routing information in that format, which will be added as extra routes on the system. Most systems will not need this information.

{% highlight bash %}
--static-routes="192.168.1.0/16:192.168.1.1 172.16.0.0/16:172.16.0.1"
{% endhighlight %}

#### --netmask (formerly --subnet)
This is the netmask of the interface, for example 255.255.255.0.

#### --virt-bridge
**(Virt-only)** When specified, koan will associate the given interface with the physical bridge on the system. If no bridge is specified, this value will be inherited from the profile, which in turn may be inherited from the default virt bridge configured in {% linkup title:"Cobbler Settings" extrameta:2.4.0 %}.

### Get Kickstart (getks)

The getks command shows the rendered kickstart/response file (preseed, etc.) for the given system. This is useful for previewing what will be downloaded from Cobbler when the system is building. This is also a good opportunity to catch snippets that are not rendering correctly.

As with remove, the --name option is required and is the only valid argument.

**Example:**

{% highlight bash %}
$ cobbler system getks --name=foo | less
{% endhighlight %}

### Power Commands

By configuring the --power-* options above, Cobbler can be used to power on/off and reboot systems in your environment.

**Example:**

{% highlight bash %}
$ cobbler system poweron --name=foo
{% endhighlight %}

Please see the {% linkup title:"Power Management" extrameta:2.4.0 %} section for more details on using these commands.
