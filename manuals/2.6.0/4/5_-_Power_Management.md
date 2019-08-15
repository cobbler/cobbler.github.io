---
layout: manpage
title: Power Management
meta: 2.6.0
---

<p>Cobbler allows for linking your power management systems with cobbler, making it very easy to make changes to your systems when you want to reinstall them, or just use it to remember what the power management settings for all of your systems are. For instance, you can just change what profile they should run and flip their power states to begin the reinstall!</p>

<h2>Fence Agents</h2>

<p>Cobbler relies on fencing agents, provided by the 'cman' package for some distributions or 'fence-agents' for others. These scripts are installed in the <code>/usr/sbin</code> directories. Cobbler will automatically find any files in that directory named fence_* and allow them to be used for power management.</p>

<p><strong>NOTE:</strong> Some distros may place the fencing agents in <code>/sbin</code> - this is currently a known bug. To work around this for now, symlink the <code>/sbin/fence_*</code> scripts you wish to use to <code>/usr/sbin</code> so cobbler can find them. This will be fixed in a future version.</p>

<h2>Changes From Older Versions</h2>

<p>Cobbler versions prior to 2.2.3-2 used templates stored in <code>/etc/cobbler/power</code> to generate commands that were run as shell commands. This was changed in 2.2.3-2 to use the fencing agents ability to instead read the parameters from STDIN. This is safer, as no passwords are shown in plaintext command line options, nor can a malformed variable be used to inject improper shell commands during the fencing agent execution.</p>

<h3>New Power Templates</h3>

<p>By default, the following options are passed in to the fencing agent's STDIN:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">action=$power_mode
login=$power_user
passwd=$power_pass
ipaddr=$power_address
port=$power_id</code></pre></figure></p>

<p>The variables above correspond to the --power-* options available when adding/editing a system (or via the "Power Management" tab in the Web UI). If you wish to add aditional options, you can create a template in <code>/etc/cobbler/power</code> named fence_&lt;name&gt;.template, where name is the fencing agent you wish to use.</p>

<p>Any additional options should be added one per line, as described in the fencing agents man page. Additional variables can be used if they are set in --ksmeta.</p>

<h3>Custom Fencing Agents</h3>

<p>If you would like to use a custom fencing agent not provided by your distribution, you can do so easily by placing it in the <code>/usr/sbin</code> directory and name it fence_&lt;mytype&gt;. Just make sure that your custom program reads its options from STDIN, as noted above.</p>

<h2>Defaults</h2>

<p>If --power-user and --power-pass are left blank, the values of default_power_user and default_power_pass will be loaded from cobblerd's environment at the time of usage.</p>

<p>--power-type also has a default value in <code>/etc/cobbler/settings</code>, initially set to "ipmilan".</p>

<h2>Important: Security Implications</h2>

<p>Storing the power control usernames and passwords in Cobbler means that information is essentially public (this data is available via XMLRPC without access control), therefore you will want to control what machines have network access to contact the power management devices if you use this feature (such as /only/ the cobbler machine, and then control who has local access to the cobbler machine). Also do not reuse important passwords for your power management devices. If this concerns you, you can still use this feature, just don't store the username/password in Cobbler for your power management devices.</p>

<p>If you are not going to to store power control passwords in Cobbler, leave the username and password fields blank. Cobbler will first try to source them from it's environment using the COBBLER_POWER_USER and COBBLER_POWER_PASS variables.</p>

<p>This may also be too insecure for some, so in this case, don't set these, and supply --power-user and --power-pass when running commands like "cobbler system poweron" and "cobbler system poweroff". The values used on the command line are always used, regardless of the value stored in Cobbler or the environment, if so provided.</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler system poweron --name=foo --power-user=X --power-pass=Y</code></pre></figure></p>

<p>Be advised of current limitations in storing passwords, make your choices accordingly and in relation to the ease-of-use that you need, and secure your networks appropriately.</p>

<h2>Sample Use</h2>

<h3>Configuring Power Options on a System</h3>

<p>You have a DRAC based blade:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler system edit --name=foo --power-type=drac --power-address=blade-mgmt.example.org --power-user=Administrator --power-pass=PASSWORD --power-id=blade7</code></pre></figure></p>

<p>You have an IPMI based system:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler system edit --name=foo --power-type=ipmilan --power-address=foo-mgmt.example.org --power-user=Administrator --power-pass=PASSWORD</code></pre></figure></p>

<p>You have a IBM HMC managed system:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler system edit --name=foo --power-type=lpar --power-address=ibm-hmc.example.org --power-user=hscroot --power-pass=PASSWORD --power-id=system:partition</code></pre></figure></p>

<p><strong>NOTE</strong>: The --power-id option is used to indicate both the managed system name <strong>and</strong> a logical partition name. Since an IBM HMC is responsible for managing more than one system, you must supply the managed system name and logical partition name separated by a colon (':') in the --power-id command-line option.</p>

<p>You have an IBM Bladecenter:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler system edit --name=foo --power-type=bladecenter --power-address=blademm.example.org --power-user=USERID --power-pass=PASSW0RD --power-id=6</code></pre></figure></p>

<p><strong>NOTE</strong>: The <em>--power-id</em> option is used to specify what slot your blade is connected.</p>

<h3>Powering Off A System</h3>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler system poweroff --name=foo</code></pre></figure></p>

<h3>Powering On A System</h3>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler system poweron --name=foo</code></pre></figure></p>

<p>If --netboot-enabled is not set to false, the system could potentially reinstall itself if PXE has been configured, so make sure to disable that option when using power management features.</p>

<h3>Rebooting A System</h3>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler system reboot --name=foo</code></pre></figure></p>

<p>Since not all power management systems support reboot, this is a "power off, sleep for 1 second, and power on" operation.</p>
