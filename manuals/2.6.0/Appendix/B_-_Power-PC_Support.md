---
layout: manpage
title: Power PC support
meta: 2.6.0
---

<p>Cobbler includes support for provisioning Linux on PowerPC systems.
This document will address how cobbler PowerPC support differs from
cobbler support for more common architectures, including i386 and
x86_64.</p>

<h2>Setup</h2>

<p>Support for network booting PowerPC systems is much like support
for network booting x86 systems using PXE. However, since PXE is
not available for PowerPC, <a href="http://yaboot.ozlabs.org">yaboot</a> is
used to network boot your PowerPC systems. To start, you must
adjust the boot device order on your system so that a network
device is first. On x86-based architectures, this configuration
change would be accomplished by entering the BIOS. However,
[en.wikipedia.org/wiki/Open_Firmware Open Firmware] is often used
in place of a BIOS on PowerPC platforms. Different PowerPC
platforms offer different methods for accessing Open Firmware. The
common procedures are outlined at
<a href="http://en.wikipedia.org/wiki/Open_Firmware#Access">http://en.wikipedia.org/wiki/Open_Firmware#Access</a>.
The following example demonstrates updating the boot device order.</p>

<p>Once at an Open Firmware prompt, to display current device aliases
use the <code>devalias</code> command. For example:</p>

<pre><code>0 &gt; devalias 
ibm,sp              /vdevice/IBM,sp@4000
disk                /pci@800000020000002/pci@2,4/pci1069,b166@1/scsi@1/sd@5,0
network             /pci@800000020000002/pci@2/ethernet@1
net                 /pci@800000020000002/pci@2/ethernet@1
network1            /pci@800000020000002/pci@2/ethernet@1,1
scsi                /pci@800000020000002/pci@2,4/pci1069,b166@1/scsi@0
nvram               /vdevice/nvram@4002
rtc                 /vdevice/rtc@4001
screen              /vdevice/vty@30000000
 ok
</code></pre>

<p>To display the current boot device order, use the <code>printenv</code>
command. For example:</p>

<pre><code>0 &gt; printenv boot-device 
-------------- Partition: common -------- Signature: 0x70 ---------------
boot-device              /pci@800000020000002/pci@2,3/ide@1/disk@0 /pci@800000020000002/pci@2,4/pci1069,b166@1/scsi@1/sd@5,0 
 ok
</code></pre>

<p>To add the device with alias <strong>network</strong> as the first boot device,
use the <code>setenv</code> command. For example:</p>

<pre><code>0 &gt; setenv boot-device network /pci@800000020000002/pci@2,3/ide@1/disk@0 /pci@800000020000002/pci@2,4/pci1069,b166@1/scsi@1/sd@5,0
</code></pre>

<p>Your system is now configured to boot off of the device with alias
<strong>network</strong> as the first boot device. Should booting off this
device fail, your system will fallback to the next device listed in
the <strong>boot-device</strong> Open Firmware settings.</p>

<h2>System-based configuration</h2>

<p>To begin, you need to first configure a Cobbler server. Cobbler can
be run on any Linux system accessible by the your PowerPC system,
including an x86 system, or another PowerPC system. This server's
primary responsibility is to host the Linux install tree(s)
remotely, and maintain information about clients accessing it. For
detailed instructions on configuring the Cobbler server, see:</p>

<p><a href="https://fedorahosted.org/cobbler/UserDocumentation">https://fedorahosted.org/cobbler/UserDocumentation</a></p>

<p>Next, it's time to add a system to cobbler. The following command
will add a system named <em>ibm-505-lp1</em> to cobbler. Note that the
cobbler profile specified (<em>F-11-GOLD-ppc64</em>) must already exist.</p>

<pre><code>cobbler system add --name ibm-505-lp1 --hostname ibm-505-lp1.example.com \
  --profile F-11-GOLD-ppc64 --kopts "console=hvc0 serial" \
  --interface 0 --mac 00:11:25:7e:28:64
</code></pre>

<p>Most of the options to cobbler system add are self explanatory
network parameters. They are fully explained in the cobbler man
page (see man cobbler). The --kopts option is used to specify any
system-specific kernel options required for this system. These will
vary depending on the nature of the system and connectivity. In the
example above, I chose to redirect console output to a device
called <em>hvc0</em> which is a specific console device available in some
virtualized guest environments (including KVM and PowerPC virtual
guests).</p>

<p>In the example above, only one MAC address was specified. If
network booting from additional devices is desired, you may wish to
add more MAC addresses to your system configuration in cobbler. The
following commands demonstrate adding additional MAC addresses:</p>

<pre><code>cobbler system edit --name ibm-505-lp1 --interface 1 --mac 00:11:25:7e:28:65
cobbler system edit --name ibm-505-lp1 --interface 2 --mac 00:0d:60:b9:6b:c8
</code></pre>

<div class="alert alert-info alert-block"><b>Note:</b> Providing a MAC address is required for proper network boot</div>


<p>support using yaboot.</p>

<h2>Profile-based configuration</h2>

<p>Profile-based network installations using yaboot are not available
at this time. OpenFirmware is only able to load a bootloader into
memory once. Once, yaboot is loaded into memory from a network
location, you are not able to exit and load an on-disk yaboot.
Additionally, yaboot requires specific device locations in order to
properly boot. At this time there is no <em>local</em> boot target as
there are in PXE configuration files.</p>

<h2>Troubleshooting</h2>

<h3>OpenFirmware Ping test</h3>

<p>If available, some PowerPC systems offer a management interface
available from the boot menu or accessible from OpenFirmware
directly. On IBM PowerPC systems, this interface is called SMS.</p>

<p>To enter SMS while your IBM PowerPC system is booting, press <em>1</em>
when prompted during boot up. A sample boot screen is shown below:</p>

<pre><code>IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 

          1 = SMS Menu                          5 = Default Boot List
          8 = Open Firmware Prompt              6 = Stored Boot List


     Memory      Keyboard     Network     SCSI    
</code></pre>

<p>To enter SMS from an OpenFirmware prompt, type:</p>

<pre><code>dev /packages/gui obe
</code></pre>

<p>Once you've entered the SMS, you should see an option menu similar
to:</p>

<pre><code> SMS 1.6 (c) Copyright IBM Corp. 2000,2005 All rights reserved.
-------------------------------------------------------------------------------
 Main Menu
 1.   Select Language
 2.   Setup Remote IPL (Initial Program Load)
 3.   Change SCSI Settings
 4.   Select Console
 5.   Select Boot Options
</code></pre>

<p>To perform the ping test:</p>

<ol>
<li>Select <code>Setup Remote IPL</code></li>
<li><p>Select the appropriate network device to use
    -------------------------------------------------------------------------------
     NIC Adapters
          Device                          Location Code                 Hardware
                                                                        Address</p>

<pre><code> 1.  Port 1 - IBM 2 PORT 10/100/100  U789F.001.AAA0060-P1-T1  0011257e2864
 2.  Port 2 - IBM 2 PORT 10/100/100  U789F.001.AAA0060-P1-T2  0011257e2865
</code></pre></li>
<li><p>Select <code>IP Parameters</code>
    -------------------------------------------------------------------------------
     Network Parameters
    Port 1 - IBM 2 PORT 10/100/1000 Base-TX PCI-X Adapter: U789F.001.AAA0060-P1-T1</p>

<pre><code> 1.   IP Parameters
 2.   Adapter Configuration
 3.   Ping Test
 4.   Advanced Setup: BOOTP
</code></pre></li>
<li><p>Enter your local network settings
    -------------------------------------------------------------------------------
     IP Parameters
    Port 1 - IBM 2 PORT 10/100/1000 Base-TX PCI-X Adapter: U789F.001.AAA0060-P1-T1</p>

<pre><code> 1.   Client IP Address                    [0.0.0.0]
 2.   Server IP Address                    [0.0.0.0]
 3.   Gateway IP Address                   [0.0.0.0]
 4.   Subnet Mask                          [0.0.0.0]
</code></pre></li>
<li><p>When complete, press <code>Esc</code>, and select <code>Ping Test</code></p></li>
</ol>


<p>The results of this test will confirm whether your network settings
are functioning properly.</p>

<h3>Confirm Cobbler Settings</h3>

<p>Is your system configured to netboot? Confirm this by using the
following command:</p>

<pre><code># cobbler system report --name ibm-505-lp1 | grep netboot 
netboot enabled?      : True
</code></pre>

<h3>Confirm Cobbler Configuration Files</h3>

<p>Cobbler stores network boot information for each MAC address
associated with a system. When a PowerPC system is configured for
netbooting, a cobbler will create the following two files inside
the tftp root directory:</p>

<ul>
<li>ppc/01-&lt;MAC_ADDRESS> - symlink to the ../yaboot</li>
<li>etc/01-&lt;MAC_ADDRESS> - a yaboot.conf configuration</li>
</ul>


<p>Confirm that the expected boot and configuration files exist for
each MAC address. A sample configuration is noted below:</p>

<pre><code># for MAC in $(cobbler system report --name ibm-505-lp1 | grep mac | gawk '{print $4}' | tr ':' '-');
do
    ls /var/lib/tftpboot/{ppc,etc}/01-$MAC ;
done
/var/lib/tftpboot/etc/01-00-11-25-7e-28-64
/var/lib/tftpboot/ppc/01-00-11-25-7e-28-64
/var/lib/tftpboot/etc/01-00-11-25-7e-28-65
/var/lib/tftpboot/ppc/01-00-11-25-7e-28-65
/var/lib/tftpboot/etc/01-00-0d-60-b9-6b-c8
/var/lib/tftpboot/ppc/01-00-0d-60-b9-6b-c8
</code></pre>

<h3>Confirm Permissions</h3>

<p>Be sure that SELinux file context's and file permissions are
correct. SELinux file context information can be reset according to
your system policy by issuing the following command:</p>

<pre><code># restorecon -R -v /var/lib/tftpboot 
</code></pre>

<p>To identify any additional permissions issues, monitor the system
log file <code>/var/log/messages</code> and the SELinux audit log
<code>/var/log/audit/audit.log</code> while attempting to netboot your
system.</p>

<h3>Latest yaboot?</h3>

<p>Network boot support requires a fairly recent yaboot. The yaboot
included in cobbler-1.4.x may not support booting recent Fedora
derived distributions. Before reporting a bug, try updating to the
latest yaboot binary. The latest yaboot binary is available from
Fedora rawhide at
<a href="http://download.fedoraproject.org/pub/fedora/linux/development/ppc/os/ppc/chrp/yaboot">http://download.fedoraproject.org/pub/fedora/linux/development/ppc/os/ppc/chrp/yaboot</a>.</p>

<h2>References</h2>

<ul>
<li>Additional OpenFirmware information available at
<a href="http://oss.gonicus.de/openpower/index.php/OpenFirmware">http://oss.gonicus.de/openpower/index.php/OpenFirmware</a></li>
</ul>
