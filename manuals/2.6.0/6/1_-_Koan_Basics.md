
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/6_-_Koan.html">6</a> <span class="divider">/</span></li><li class="active">Cobbler Manual</li></ul>
   <h1>Cobbler Manual</h1>
<h3>Koan</h3>

<p>perhaps it stands for "kickstart over a network", koan is a helper client side helper for cobbler.  It's kind of a play on "Xen" too.</p>

<h3>SYNOPSIS</h3>

<pre><code>koan --server=hostname [--list=type] [--virt|--replace-self|--display] [--profile=name] [--system=name] [--image=name] [--add-reinstall-entry] [--virt-name=name] [--virt-path=path] [--virt-type=type] [--nogfx] [--static-interface=name] [--kexec]
</code></pre>

<h3>DESCRIPTION</h3>

<p>Koan is a client-side helper program for use with Cobbler.  koan allows for both network provisioning of new virtualized guests (Xen, QEMU/KVM, VMware) and re-installation of an existing system.</p>

<p>When invoked, koan requests install information from a remote cobbler boot server, it then kicks off installations based on what is retrieved from cobbler and fed in on the koan command line.   The examples below show the various use cases.</p>

<h3>LISTING REMOTE COBBLER OBJECTS</h3>

<p>To browse remote objects on a cobbler server and see what you can install using koan, run one of the following commands:</p>

<pre><code>koan --server=cobbler.example.org --list=profiles

koan --server=cobbler.example.org --list=systems

koan --server=cobbler.example.org --list=images
</code></pre>

<h3>LEARNING MORE ABOUT REMOTE COBBLER OBJECTS</h3>

<p>To learn more about what you are about to install, run one of the following commands:</p>

<pre><code>koan --server=cobbler.example.org --display --profile=name

koan --server=cobbler.example.org --display --system=name

koan --server=cobbler.example.org --display --image=name
</code></pre>

<h3>REINSTALLING EXISTING SYSTEMS</h3>

<p>Using --replace-self will reinstall the existing system the next time you reboot.</p>

<p>   koan --server=cobbler.example.org --replace-self --profile=name</p>

<p>   koan --server=cobbler.example.org --replace-self --system=name</p>

<p>Additionally, adding the flag --add-reinstall-entry will make it add the entry to grub for reinstallation
but will not make it automatically pick that option on the next boot.</p>

<p>Also the flag --kexec can be appended, which will launch the installer without needing to reboot.  Not
all kernels support this option.</p>

<h3>INSTALLING VIRTUALIZED SYSTEMS</h3>

<p>Using --virt will install virtual machines as defined by Cobbler.  There are various
overrides you can use if not everything in cobbler is defined as you like it.</p>

<pre><code>koan --server=cobbler.example.org --virt --profile=name

koan --server=cobbler.example.org --virt --system=name

koan --server=cobbler.example.org --virt --image=name
</code></pre>

<p>Some of the overrides that can be used with --virt are:</p>

<p>Flag                Explanation                             Example</p>

<p>--virt-name         name of virtual machine to create       testmachine</p>

<p>--virt-type         forces usage of qemu/xen/vmware         qemu</p>

<p>--virt-bridge       name of bridge device                   virbr0</p>

<p>--virt-path         overwrite this disk partition           /dev/sda4</p>

<p>--virt-path         use this directory                      /opt/myimages</p>

<p>--virt-path         use this existing LVM volume            VolGroup00</p>

<p>--nogfx             do not use VNC graphics (Xen only)      (does not take options)</p>

<p>Nearly all of these variables can also be defined and centrally managed by the Cobbler server.</p>

<p>If installing virtual machines in environments without DHCP, use of --system instead of --profile is required.  Additionally use --static-interface=eth0 to supply which interface to use to supply network information.  The installer will boot from this virtual interface.  Leaving off --static-interface will result in an unsuccessful network installation.</p>

<h3>CONFIGURATION MANAGEMENT</h3>

<p>Using --update-config will update a system configuration as defined by Cobbler.</p>

<p>koan --server=cobbler.example.org --update-config</p>

<p>Additionally, adding the flag --summary will print configuration run stats.</p>

<p>Koan passes in the system's FQDN in the background during the configuration request. Cobbler will match this FQDN to a configured system defined by Cobbler.</p>

<p>The FQDN (Fully Qualified Domain Name) maps to the system's hostname field.</p>

<h3>ENVIRONMENT VARIABLES</h3>

<p>Koan respects the COBBLER_SERVER variable to specify the cobbler server to use.  This is a convenient way to avoid using the --server option for each command.  This variable is set automatically on systems installed via cobbler, assuming standard kickstart templates are used.  If you need to change this on an installed system, edit /etc/profile.d/cobbler.{csh,sh}.</p>
