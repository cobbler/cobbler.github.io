
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/3_-_General_Topics.html">3</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/3/2_-_Cobbler_Direct_Commands.html">2</a> <span class="divider">/</span></li><li class="active">Distro Signatures</li></ul>
   <h1>Distro Signatures</h1>
<p>Prior to Cobbler 2.4.0, import modules for each supported distro were separate and customized for each specific distribution. The values for breed and os-version were hard-coded into cobbler, so adding support for new distros or newer versions of an already supported distro required code changes and a complete Cobbler upgrade.</p>

<p>Cobbler 2.4.0 introduces the concept of distro signatures to make adding support for newer distro versions without requiring an upgrade to the rest of the system.</p>

<h3>Distro Signatures File</h3>

<p>The distro signatures are stored in <code>/var/lib/cobbler/distro_signatures.json</code>. As the extension indicates, this is a JSON-formatted file, with the following structure:</p>

<p><figure class="highlight"><pre><code class="language-json" data-lang="json">{&quot;breeds&quot;:
 {
  &quot;&lt;breed-name&gt;&quot;: {
   &quot;&lt;os-version1&gt;&quot;: {
    &quot;signatures&quot;: &quot;...&quot;,
    &quot;default_kickstart&quot;:&quot;...&quot;,
    ...
   },
   ...
  }
  ...
 }
}</code></pre></figure></p>

<p>This file is read in when cobblerd starts, and logs a message noting how many breeds and os-versions it has loaded:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">INFO | 9 breeds and 21 OS versions read from the signature file</code></pre></figure></p>

<h3>CLI Commands</h3>

<p>The signature CLI command has the following sub-commands:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler signature --help</p>

<h1>usage</h1>

<p>cobbler signature report
cobbler signature update</code></pre></figure></p>

<h4>cobbler signature report</h4>

<p>This command prints out a report of the currently loaded signatures and os-versions.</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler signature report
Currently loaded signatures:
debian:
    squeeze
freebsd:
    8.2
    8.3
    9.0
generic:
    (none)
redhat:
    fedora16
    fedora17
    fedora18
    rhel4
    rhel5
    rhel6
suse:
    opensuse11.2
    opensuse11.3
    opensuse11.4
    opensuse12.1
    opensuse12.2
ubuntu:
    oneiric
    precise
    quantal
unix:
    (none)
vmware:
    esx4
    esxi4
    esxi5
windows:
    (none)</p>

<p>9 breeds with 21 total signatures loaded</code></pre></figure></p>

<p>An optional --name parameter can be specified to limit the report to one breed:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler signature report --name=ubuntu
Currently loaded signatures:
ubuntu:
    oneiric
    precise
    quantal</p>

<p>Breed &#39;ubuntu&#39; has 3 total signatures</code></pre></figure></p>

<h4>cobbler signature update</h4>

<p>This command will cause Cobbler to go and fetch the latest distro signature file from http://cobbler.github.con/signatures/latest.json, and load the signatures in that file. This file will be tested first, to ensure it is formatted correctly.</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">cobbler signature update
task started: 2012-11-21_222926_sigupdate
task started (id=Updating Signatures, time=Wed Nov 21 22:29:26 2012)
Successfully got file from http://cobbler.github.com/signatures/latest.json
<strong><em> TASK COMPLETE </em></strong></code></pre></figure></p>

<p>This command currently takes no options.</p>
