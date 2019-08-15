
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4_-_Advanced_Topics.html">4</a> <span class="divider">/</span></li><li class="active">Using gPXE</li></ul>
   <h1>Using gPXE</h1>
<p>Support for gPXE (and by extension, iPXE) was added in 2.2.3 for booting ESXi5 installations, however it can be used for other installations as well.</p>

<div class="alert alert-info alert-block"><b>Note:</b> gPXE/iPXE support is still somewhat experimental, so use it only when required.</div>


<h2>Setup</h2>

<p>First, install the gpxe/ipxe boot images package for your OS (for RHEL variants and Fedora, the package name is gpxe-bootimgs or ipxe-bootimgs). Cobbler sync does not currently copy the undionly.kpxe file to the TFTP root directory. Again, for RHEL/Fedora you'd do something like this:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cp /usr/share/ipxe/undionly.kpxe /var/lib/tftpboot/</code></pre></figure></p>

<h2>Configuring Systems/Profiles</h2>

<p>Via the CLI or Web UI, just enable the gpxe option. For example:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler system edit --name=foo --enable-gpxe=1 --interface=eth0 --static=1</code></pre></figure></p>

<p>When using <code>manage_dhcp</code>, a new entry for systems with static interfaces will be created as follows (following a "cobbler sync"):</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">host generic1 {
        hardware ethernet xx:xx:xx:xx:xx:xx;
        if exists user-class and option user-class = &quot;gPXE&quot; {
            filename &quot;http://&lt;cobbler server ip&gt;/cblr/svc/op/gpxe/system/foo&quot;;
        } else {
            filename &quot;undionly.kpxe&quot;;
        }
        next-server &lt;next-server setting&gt;;
    }</code></pre></figure></p>

<p>Profiles and systems that use DHCP for addresses are handled by the default network block included in the <code>dhcp.template</code>.</p>

<p>If you're not using DHCP locally, you can just use the URL above with your custom gPXE/iPXE script: <code>http://&lt;cobbler server ip&gt;/cblr/svc/op/gpxe/system/foo</code>.</p>

<p>Here is a sample of the rendered configuration:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">#!gpxe
kernel http://&lt;cobbler server ip&gt;/cobbler/images/centos6.3-x86_64/vmlinuz
imgargs vmlinuz  ksdevice=bootif lang= text kssendmac  ks=http://&lt;cobbler server ip&gt;/cblr/svc/op/ks/system/foo
initrd http://192.168.122.1/cobbler/images/centos6.3-x86_64/initrd.img
boot</code></pre></figure></p>

<h2>Templates</h2>

<p>The templates for gPXE are stored with the other PXE templates for cobbler, in <code>/etc/cobbler/pxe</code>. The default for systems/profiles is <code>/etc/cobbler/pxe/gpxe_system_linux.template</code>, which you can see is the source for the above output:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cat /etc/cobbler/pxe/gpxe_system_linux.template</p>

<h1>!gpxe</h1>

<p>kernel http://$server/cobbler/images/$distro/$kernel_name
imgargs $kernel_name $append_line
initrd http://$server/cobbler/images/$distro/$initrd_name
boot</code></pre></figure></p>

<p>As with all PXE templates, the <code>$append_line</code> variable is generated internally by cobbler, and contains the kopts arguments as well as other distro defaults that may be configured.</p>
