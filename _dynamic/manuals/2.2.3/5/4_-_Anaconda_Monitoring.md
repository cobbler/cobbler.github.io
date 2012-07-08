---
layout: manpage
title: Anaconda Monitoring
meta: 2.2.3
---

# {{ page.title }}

This page details the **Ana**conda **Mon**itoring service available in cobbler.  As anamon is rather distribution specific, support for it is considered deprecated at this time.

## History

Prior to Cobbler 1.6 , remote monitoring of installing systems was
limited to distributions that accept the the boot argument
*syslog=*. While this is supported in RHEL-5 and newer Red Hat
based distributions, it has several shortcomings.

#### Reduces available kernel command-line length

The kernel command-line has a limited amount of space, relying on *syslog=somehost.example.com* reduces available argument space. Cobbler has smarts to not add the *syslog=* parameter if no space is available. But doing so disables remote monitoring.

#### Only captures syslog

The *syslog=* approach will only capture syslog-style messages. Any command-specific output (/tmp/lvmout, /tmp/ks-script, /tmp/X.config) or installation failure (/tmp/anacdump.txt) information is not sent.

#### Unsupported on older distros

While capturing syslog information is key for remote monitoring of installations, the [anaconda](http://fedoraproject.org/wiki/Anaconda) installer only supports sending syslog data for RHEL-5 and newer distributions.

## What is Anamon?

In order to overcome the above obstacles, the *syslog=* remote monitoring has been replaced by a python service called **anamon** (Anaconda Monitor). Anamon is a python daemon (which runs inside the installer while it is installing) that connects to the cobbler server via XMLRPC and uploads a pre-determined set of files. Anamon will continue monitoring files for updates and send any new data to the cobbler server.

## Using Anamon

To enable anamon for your Red Hat based distribution installations, edit */etc/cobbler/settings* and set:

{% highlight yaml %}
anamon_enabled: 1
{% endhighlight %}

**NOTE:** Enabling anamon allows an xmlrpc call to send create and update log files in the anamon directory, without authentication, so enable only if you are ok with this limitation. It could be potentially used by users to flood the log files or fill up the server, which you probably don't want in an untrusted environment.  However, even so, it may be good for debugging complex installs.

You will also need to update your kickstart templates to include the following snippets.

{% highlight bash %}
%pre
$SNIPPET('pre_anamon')
{% endhighlight %}

Anamon can also send /var/log/messages and /var/log/boot.log once your provisioned system has booted. To also enable post-install boot notification, you must enable the following snippet:

{% highlight bash %}
%post
$SNIPPET('post_anamon')
{% endhighlight %}

## Where Is Information Saved?

All anamon logs are stored in a system-specific directory under */var/log/cobbler/anamon/systemname*. For example,

{% highlight bash %}
$ ls /var/log/cobbler/anamon/vguest3
anaconda.log  boot.log  dmesg  install.log  ks.cfg  lvmout.log  messages  sys.log
{% endhighlight %}

## Older Distributions

Anamon relies on a %pre installation script that uses a python *xmlrpc* library. The installation image used by Red Hat Enterprise Linux 4 and older distributions for **http://** installs does not provide the needed python libraries. There are several ways to get around this ...

1.  Always perform a graphical or **vnc** install - installing graphically (or by vnc) forces anaconda to download the *stage2.img* that includes graphics support **and** the required python xmlrpc library.
2.  Install your system over nfs - nfs installations will also use the *stage2.img* that includes python xmlrpc support
3.  Install using an *updates.img* - Provide the missing xmlrpc library by building an updates.img for use during installation. To construct an *updates.img*, follow the steps below:

{% highlight bash %}
$ dd if=/dev/zero of=updates.img bs=1k count=1440
$ mke2fs updates.img
$ tmpdir=`mktemp -d`
$ mount -o loop updates.img $tmpdir
$ mkdir $tmpdir/cobbler
$ cp /usr/lib64/python2.3/xmlrpclib.* $tmpdir/cobbler
$ cp /usr/lib64/python2.3/xmllib.* $tmpdir/cobbler
$ cp /usr/lib64/python2.3/shlex.* $tmpdir/cobbler
$ cp /usr/lib64/python2.3/lib-dynload/operator.* $tmpdir/cobbler
$ umount $tmpdir
$ rmdir $tmpdir
{% endhighlight %}

More information on building and using an *updates.img* is available from [http://fedoraproject.org/wiki/Anaconda/Updates](http://fedoraproject.org/wiki/Anaconda/Updates).
