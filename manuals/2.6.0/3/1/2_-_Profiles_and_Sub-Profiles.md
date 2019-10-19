---
layout: manpage
title: Profiles & Sub-Profiles
meta: 2.6.0
---

A profile associates a distribution to additional specialized options, such as a kickstart automation file. Profiles are
the core unit of provisioning and at least one profile must exist for every distribution to be provisioned. A profile
might represent, for instance, a web server or desktop configuration. In this way, profiles define a role to be
performed.

The profile command has the following sub-commands: `$ cobbler profile --help`

Usage:

{% highlight bash %}
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

**Example:** `$ cobbler profile add --name=string --distro=string [options]`

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
  <td>A descriptive name. This could be something like "rhel5webservers" or "f9desktops".</td>
 </tr>
 <tr>
  <td class="nowrap">--distro (required)</td>
  <td>The name of a previously defined cobbler distribution. This value is required.</td>
 </tr>
 <tr>
  <td class="nowrap">--boot-files</td>
  <td>This option is used to specify additional files that should be copied to the TFTP directory for the distro so that
  they can be fetched during earlier stages of the installation. Some distributions (for example, VMware ESXi) require
  this option to function correctly.</td>
 </tr>
 <tr>
  <td class="nowrap">--clobber</td>
  <td>This option allows "add" to overwrite an existing profile with the same name, so use it with caution.</td>
 </tr>
 <tr>
  <td class="nowrap">--comment</td>
  <td>An optional comment to associate with this profile.</td>
 </tr>
 <tr>
  <td class="nowrap">--dhcp-tag</td>
  <td>
   <p>DHCP tags are used in the dhcp.template when using multiple networks.</p>
   <p>Please refer to the <a href="/manuals/2.6.0/3/4/1_-_Managing_DHCP.html">Managing DHCP</a> section for more
   details.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--enable-gpxe</td>
  <td>
   <p>When enabled, the system will use gPXE instead of regular PXE for booting.</p>
   <p>Please refer to the <a href="/manuals/2.6.0/4/13_-_Using_gPXE.html">Using gPXE</a> section for details on using
   gPXE for booting over a network.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--enable-menu</td>
  <td>When managing TFTP, Cobbler writes the `${tftproot}/pxelinux.cfg/default` file, which contains entries for all
  profiles. When this option is enabled for a given profile, it will not be added to the default menu.</td>
 </tr>
 <tr>
  <td class="nowrap">--fetchable-files</td>
  <td>
   <p>This option is used to specify a list of key=value files that can be fetched via the python based TFTP server. The
   "value" portion of the name is the path/name they will be available as via TFTP.</p>
   <p>Please see the <a href="/manuals/2.6.0/3/4/4_-_Managing_TFTP.html">Managing TFTP</a> section for more details on
   using the python-based TFTP server.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--in-place</td>
  <td>By default, any modifications to key=value fields (ksmeta, kopts, etc.) do no preserve the contents. To preserve
  the contents of these fields, --in-place should be specified. This option is also required is using a key with
  multiple values (for example, "foo=bar foo=baz").</td>
 </tr>
 <tr>
  <td class="nowrap">--kickstart</td>
  <td>
   <p>Local filesystem path to a kickstart file. http:// URLs (even CGI’s) are also accepted, but a local file path is
   recommended, so that the kickstart templating engine can be taken advantage of.</p>
   <p>If this parameter is not provided, the kickstart file will default to `/var/lib/cobbler/kickstarts/default.ks`.
   This file is initially blank, meaning default kickstarts are not automated "out of the box". Admins can change the
   default.ks if they desire.</p>
   <p>When using kickstart files, they can be placed anywhere on the filesystem, but the recommended path is
   <code>/var/lib/cobbler/kickstarts</code>. If using the webapp to create new kickstarts, this is where the web
   application will put them.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--kopts</td>
  <td>
   <p>Sets kernel command-line arguments that the profile, and sub-profiles/systems dependant on it, will use during
   installation only. This field is a hash field, and accepts a set of key=value pairs:</p>
   <p><b>Example:</b></p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash">--kopts=&quot;console=tty0 console=ttyS0,8,n,1 noapic&quot;</code></pre></figure>

  </td>
 </tr>
 <tr>
  <td class="nowrap">--kopts-post</td>
  <td>This is just like --kopts, though it governs kernel options on the installed OS, as opposed to kernel options fed
  to the installer. This requires some special snippets to be found in your kickstart template to work correctly.</td>
 </tr>
 <tr>
  <td class="nowrap">--ksmeta</td>
  <td>
   <p>This is an advanced feature that sets variables available for use in templates. This field is a hash field, and
   accepts a set of key=value pairs:</p>
   <p><b>Example:</b></p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash">--ksmeta=&quot;foo=bar baz=3 asdf&quot;</code></pre></figure>

   <p>See the section on <a href="/manuals/2.6.0/3/5_-_Kickstart_Templating.html">Kickstart Templating</a> for further
   information.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--mgmt-classes<br />--mgmt-parameters</td>
  <td>
   <p>Management classes and parameters that should be associated with this profile for use with configuration
   management systems.</p>
   <p>Please see the <a href="/manuals/2.6.0/4/3_-_Configuration_Management.html">Configuration Management</a> section
   for more details on integrating Cobbler with configuration management systems.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--name-servers</td>
  <td>If your nameservers are not provided by DHCP, you can specify a space seperated list of addresses here to
  configure each of the installed nodes to use them (provided the kickstarts used are installed on a per-system basis).
  Users with DHCP setups should not need to use this option. This is available to set in profiles to avoid having to set
  it repeatedly for each system record.</td>
 </tr>
 <tr>
  <td class="nowrap">--name-servers-search</td>
  <td>As with the --name-servers option, this can be used to specify the default domain search line. Users with DHCP
  setups should not need to use this option. This is available to set in profiles to avoid having to set it repeatedly
  for each system record.</td>
 </tr>
 <tr>
  <td class="nowrap">--owners</td>
  <td>
   <p>The value for --owners is a space seperated list of users and groups as specified in
   <code>/etc/cobbler/users.conf</code>.</p>
   <p>Users with small sites and a limited number of admins can probably ignore this option, since it only applies to
   the Cobbler WebUI and XMLRPC interface, not the "cobbler" command line tool run from the shell. Furthermore, this is
   only respected when using the "authz_ownership" module which must be enabled and is not the default.</p>
   <p>Please see the <a href="/manuals/2.6.0/5/3_-_Web_Authorization.html">Web Authorization</a> section for more
   details.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--parent</td>
  <td>
   <p>This is an advanced feature.</p>
   <p>Profiles may inherit from other profiles in lieu of specifing --distro. Inherited profiles will override any
   settings specified in their parent, with the exception of --ksmeta (templating) and --kopts (kernel options), which
   will be blended together.</p>
   <p><b>Example:</b></p>
   <p>If profile A has --kopts="x=7 y=2", B inherits from A, and B has --kopts="x=9 z=2", the actual kernel options that
   will be used for B are "x=9 y=2 z=2".</p>
   <p><b>Example:</b></p>
   <p>If profile B has --virt-ram=256 and A has --virt-ram of 512, profile B will use the value 256.</p>
   <p><b>Example:</b></p>
   <p>If profile A has a --virt-file-size of 5 and B does not specify a size, B will use the value from A.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--proxy</td>
  <td>
   <p>Specifies a proxy to use during the installation stage.</p>
   <div class="alert alert-info alert-block">
    <b>Note:</b> Not all distributions support using a proxy in this manner.
   </div>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--redhat-management-key</td>
  <td>
   <p>If you’re using Red Hat Network, Red Hat Satellite Server, or Spacewalk, you can store your authentication keys
   here and Cobbler can add the neccessary authentication code to your kickstart where the snippet named
   "redhat_register" is included. The default option specified in
   <a href="/manuals/2.6.0/3/3_-_Cobbler_Settings.html">Cobbler Settings</a> will be used if this field is left
   blank.</p>
   <p>Please see the <a href="/manuals/2.6.0/Appendix/C_-_Tips_for_RHN.html">Tips For RHN</a> section for more details
   on integrating Cobbler with RHN/Spacewalk.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--redhat-management-server</td>
  <td>
   <p>The RHN Satellite or Spacewalk server to use for registration. As above, the default option specified in
   <a href="/manuals/2.6.0/3/3_-_Cobbler_Settings.html">Cobbler Settings</a> will be used if this field is left
   blank.</p>
   <p>Please see the <a href="/manuals/2.6.0/Appendix/C_-_Tips_for_RHN.html">Tips For RHN</a> section for more details
   on integrating Cobbler with RHN/Spacewalk.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--repos</td>
  <td>This is a space delimited list of all the repos (created with "cobbler repo add" and updated with
  "cobbler reposync") that this profile can make use of during kickstart installation. For example, an example might be
  --repos="fc6i386updates fc6i386extras" if the profile wants to access these two mirrors that are already mirrored on
  the cobbler server. Repo management is described in greater depth later in the manpage.</td>
 </tr>
 <tr>
  <td class="nowrap">--server</td>
  <td>This parameter should be useful only in select circumstances. If machines are on a subnet that cannot access the
  cobbler server using the name/IP as configured in the cobbler settings file, use this parameter to override that
  server name. See also --dhcp-tag for configuring the next server and DHCP informmation of the system if you are also
  using Cobbler to help manage your DHCP configuration.</td>
 </tr>
 <tr>
  <td class="nowrap">--template-files</td>
  <td>
   <p>This feature allows cobbler to be used as a configuration management system. The argument is a space delimited
   string of key=value pairs. Each key is the path to a template file, each value is the path to install the file on the
   system. Koan also can retrieve these files from a cobbler server on demand, effectively allowing cobbler to function
   as a lightweight templated configuration management system.</p>
   <p>Please see the
   <a href="/manuals/2.6.0/4/3/1_-_Built-In_Configuration_Management.html">Built-In Configuration Management</a> section
   for more details on using template files.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--template-remote-kickstarts</td>
  <td>If enabled, any kickstart with a remote path (http://, ftp://, etc.) will not be passed through Cobbler's template
  engine.</td>
 </tr>
 <tr>
  <td class="nowrap">--virt-auto-boot</td>
  <td><b>(Virt-only)</b> When set, the VM will be configured to automatically start when the host reboots.</td>
 </tr>
 <tr>
  <td class="nowrap">--virt-bridge</td>
  <td><b>(Virt-only)</b> This specifies the default bridge to use for all systems defined under this profile. If not
  specified, it will assume the default value in the cobbler settings file, which as shipped in the RPM is ’xenbr0’. If
  using KVM, this is most likely not correct. You may want to override this setting in the system object. Bridge
  settings are important as they define how outside networking will reach the guest. For more information on bridge
  setup, see the Cobbler Wiki, where there is a section describing koan usage.</td>
 </tr>
 <tr>
  <td class="nowrap">--virt-cpus</td>
  <td><b>(Virt-only)</b> How many virtual CPUs should koan give the virtual machine?  The default for this value is set
  in the <a href="/manuals/2.6.0/3/3_-_Cobbler_Settings.html">Cobbler Settings</a> file, and should be set as an
  integer.</td>
 </tr>
 <tr>
  <td class="nowrap">--virt-disk-driver</td>
  <td><b>(Virt-only)</b> The type of disk driver to use for the disk image, for example "raw" or "qcow2".</td>
 </tr>
 <tr>

  <td class="nowrap">--virt-file-size</td>
  <td><b>(Virt-only)</b> How large the disk image should be in Gigabytes. The default for this value is set in the
  <a href="/manuals/2.6.0/3/3_-_Cobbler_Settings.html">Cobbler Settings</a> file. This can be a space seperated list
  (ex: "5,6,7") to allow for multiple disks of different sizes depending on what is given to --virt-path. This should be
  input as a integer or decimal value without units.</td>
 </tr>
 <tr>
  <td class="nowrap">--virt-path</td>
  <td>
   <p><b>(Virt-only)</b> Where to store the virtual image on the host system. Except for advanced cases, this parameter
   can usually be omitted. For disk images, the value is usually an absolute path to an existing directory with an
   optional file name component. There is support for specifying partitions "/dev/sda4"
   or volume groups "VolGroup00", etc.</p>
   <p>For multiple disks, seperate the values with commas such as "VolGroup00,VolGroup00" or "/dev/sda4,/dev/sda5". Both
   those examples would create two disks for the VM.</p>
  </td>
 </tr>
 <tr>
  <td class="nowrap">--virt-ram</td>
  <td><b>(Virt-only)</b> How many megabytes of RAM to consume. The default for this value is set in the
  <a href="/manuals/2.6.0/3/3_-_Cobbler_Settings.html">Cobbler Settings</a> file. This should be input as an integer
  without units, and will be interpretted as MB.</td>
 </tr>
 <tr>
  <td class="nowrap">--virt-type</td>
  <td><b>(Virt-only)</b> Koan can install images using several different virutalization types. Choose one or the other
  strings to specify, or values will default to attempting to find a compatible installation type on the client system
  ("auto"). See the <a href="/manuals/2.6.0/6_-_Koan.html">Koan</a> section for more documentation. The default for this
  value is set in the <a href="/manuals/2.6.0/3/3_-_Cobbler_Settings.html">Cobbler Settings</a> file.</td>
 </tr>
 <tr>
</tbody>
</table>


<h3>Get Kickstart (getks)</h3>

<p>The getks command shows the rendered kickstart/response file (preseed, etc.) for the given profile. This is useful
for previewing what will be downloaded from Cobbler when the system is building. This is also a good opportunity to
catch snippets that are not rendering correctly.</p>

<p>As with remove, the --name option is required and is the only valid argument.</p>

<p><strong>Example:</strong></p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler profile getks --name=foo | less</code></pre></figure></p>
