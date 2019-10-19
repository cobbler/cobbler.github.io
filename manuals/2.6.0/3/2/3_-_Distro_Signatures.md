---
layout: manpage
title: Distro Signatures
meta: 2.6.0
---

Prior to Cobbler 2.4.0, import modules for each supported distro were separate and customized for each specific
distribution. The values for breed and os-version were hard-coded into cobbler, so adding support for new distros or
newer versions of an already supported distro required code changes and a complete Cobbler upgrade.

Cobbler 2.4.0 introduces the concept of distro signatures to make adding support for newer distro versions without
requiring an upgrade to the rest of the system.

### Distro Signatures File

The distro signatures are stored in `/var/lib/cobbler/distro_signatures.json`. As the extension indicates, this is a
JSON-formatted file, with the following structure:

{% highlight json %}
{"breeds":
 {
  "<breed-name>": {
   "<os-version1>": {
    "signatures": "...",
    "default_kickstart":"...",
    ...
   },
   ...
  }
  ...
 }
}
{% endhighlight %}

This file is read in when cobblerd starts, and logs a message noting how many breeds and os-versions it has loaded:
`INFO | 9 breeds and 21 OS versions read from the signature file`

### CLI Commands

The signature CLI command has the following sub-commands:

<figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler signature --help

<h1>usage</h1>

cobbler signature report
cobbler signature update</code></pre></figure>

#### cobbler signature report

This command prints out a report of the currently loaded signatures and os-versions.

{% highlight bash %}
$ cobbler signature report
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
    (none)

9 breeds with 21 total signatures loaded
{% endhighlight %}

An optional --name parameter can be specified to limit the report to one breed:

{% highlight bash %}
$ cobbler signature report --name=ubuntu
Currently loaded signatures:
ubuntu:
    oneiric
    precise
    quantal

Breed 'ubuntu' has 3 total signatures
{% endhighlight %}

#### cobbler signature update

This command will cause Cobbler to go and fetch the latest distro signature file from
[http://cobbler.github.con/signatures/latest.json](http://cobbler.github.con/signatures/latest.json), and load the
signatures in that file. This file will be tested first, to ensure it is formatted correctly.

{% highlight bash %}
cobbler signature update
task started: 2012-11-21_222926_sigupdate
task started (id=Updating Signatures, time=Wed Nov 21 22:29:26 2012)
Successfully got file from http://cobbler.github.com/signatures/latest.json
TASK COMPLETE
{% endhighlight %}

This command currently takes no options.
